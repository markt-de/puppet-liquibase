# == Class: liquibase
#
# Install and configure liquibase
#
# === Parameters
#
# [version] the version you aim to install, by default the latest version is installed.
# [postgresql_version] the version of the posgresql driver to use, by default 9.3-1103-jdbc41
# [derby_version] the version of the derby driver to use, by default 10.11.1.1
# [h2_version] the version of the h2 driver to use, by default 1.4.187
# [hsqldb_version] the version of the hsqldb driver to use, by default  2.3.2
# [jtds_version] the version of the jtds driver to use, by default 1.3.1
# [mysql_version] the version of the mysql driver to use, by default 5.1.34
# [sqlite_version] the version of the sqlite driver to use, by default 3.7.8
# [environment] the proxy configuration if needed
#
#
#
# === Examples
#
#class { 'liquibase':
# version => '3.4.0',
# environment => ["http_proxy=http://proxy_user:proxy_passwd@proxy_server:proxy_port", "https_proxy=https://proxy_user:proxy_passwd@proxy_server:proxy_port"],
#}
#
#class { 'liquibase':
#}
#
# === Authors
#
# Michele BARRE <michele.barre@ville-noumea.nc>
#
# === Copyright
#
# Copyright 2015 Mairie de Noumea.
#

class liquibase::install inherits liquibase {

  # We configure this module to download files in a staging folder.
  # We assume that the staging path is define before puppet-liquibase module is called.
  # If you don't redefine staging path, default path will be the one set in the staging module => /opt/staging
  # See README.md
  include staging

  staging::file { "liquibase-${liquibase::version}-bin.tar.gz":
    environment => $environment,
    source      => "https://github.com/liquibase/liquibase/releases/download/liquibase-parent-${liquibase::version}/liquibase-${liquibase::version}-bin.tar.gz",
  }

  file { '/opt/apps/liquibase/':
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
    require => Staging::File["liquibase-${liquibase::version}-bin.tar.gz"],
  }

  file { "/opt/apps/liquibase/liquibase-${liquibase::version}":
    ensure  => directory,
    require => Staging::File["liquibase-${liquibase::version}-bin.tar.gz"],
  }

  staging::extract { "liquibase-${liquibase::version}-bin.tar.gz":
    target  => "/opt/apps/liquibase/liquibase-${liquibase::version}",
    require => Staging::File["liquibase-${liquibase::version}-bin.tar.gz"],
  }

  # Creation des liens synboliques
  file { '/opt/liquibase':
    ensure => 'link',
    target => "/opt/apps/liquibase/liquibase-${liquibase::version}",
  }

  file { '/usr/bin/liquibase':
    ensure => 'link',
    target => '/opt/liquibase/liquibase',
  }

  # Copie dans /etc/profile.d pour definir LIQUIBASE_HOME
  file { '/etc/profile.d/liquibase_env.sh':
    ensure  => present,
    owner   => root,
    group   => root,
    source  => 'puppet:///modules/liquibase/liquibase_env.sh',
    require => Staging::Extract["liquibase-${liquibase::version}-bin.tar.gz"],
  }

  # Copie des drivers
  # PostgreSQL
  staging::file { "postgresql-${liquibase::postgresql_version}.jar":
    environment => $liquibase::environment,
    source      => "http://central.maven.org/maven2/org/postgresql/postgresql/${liquibase::postgresql_version}/postgresql-${liquibase::postgresql_version}.jar",
    require     => Staging::Extract["liquibase-${liquibase::version}-bin.tar.gz"],
  }

  exec { "copy_postgresql-${liquibase::postgresql_version}.jar":
    command => "/bin/cp ${staging::path}/liquibase/postgresql-${liquibase::postgresql_version}.jar /opt/apps/liquibase/liquibase-${liquibase::version}/lib/",
    path    => '/usr/local/bin/:/bin/',
    creates => "/opt/liquibase-${liquibase::version}/lib/postgresql-${liquibase::postgresql_version}.jar",
    require => [
      Staging::Extract["liquibase-${liquibase::version}-bin.tar.gz"],
      Staging::File["postgresql-${liquibase::postgresql_version}.jar"]
    ],
  }

  # Derby
  staging::file { "derbyclient-${liquibase::derby_version}.jar":
    environment => $liquibase::environment,
    source      => "http://central.maven.org/maven2/org/apache/derby/derbyclient/${liquibase::derby_version}/derbyclient-${liquibase::derby_version}.jar",
    require     => Staging::Extract["liquibase-${liquibase::version}-bin.tar.gz"],
  }

  exec { "copy_derbyclient-${liquibase::derby_version}.jar":
    command => "/bin/cp ${staging::path}/liquibase/derbyclient-${liquibase::derby_version}.jar /opt/apps/liquibase/liquibase-${liquibase::version}/lib/",
    path    => '/usr/local/bin/:/bin/',
    creates => "/opt/apps/liquibase/liquibase-${liquibase::version}/lib/derbyclient-${liquibase::derby_version}.jar",
    require => [
      Staging::Extract["liquibase-${liquibase::version}-bin.tar.gz"],
      Staging::File["derbyclient-${liquibase::derby_version}.jar"]
    ],
  }

  # H2
  staging::file { "h2-${liquibase::h2_version}.jar":
    environment => $liquibase::environment,
    source      => "http://central.maven.org/maven2/com/h2database/h2/${liquibase::h2_version}/h2-${liquibase::h2_version}.jar",
    require     => Staging::Extract["liquibase-${liquibase::version}-bin.tar.gz"],
  }

  exec { "copy_h2-${liquibase::h2_version}.jar":
    command => "/bin/cp ${staging::path}/liquibase/h2-${liquibase::h2_version}.jar /opt/apps/liquibase/liquibase-${liquibase::version}/lib/",
    path    => '/usr/local/bin/:/bin/',
    creates => "/opt/apps/liquibase/liquibase-${liquibase::version}/lib/h2-${liquibase::h2_version}.jar",
    require => [Staging::Extract["liquibase-${liquibase::version}-bin.tar.gz"], Staging::File["h2-${liquibase::h2_version}.jar"]],
  }

  # Hsqldb
  staging::file { "hsqldb-${liquibase::hsqldb_version}.jar":
    environment => $liquibase::environment,
    source      => "http://central.maven.org/maven2/org/hsqldb/hsqldb/${liquibase::hsqldb_version}/hsqldb-${liquibase::hsqldb_version}.jar",
    require     => Staging::Extract["liquibase-${liquibase::version}-bin.tar.gz"],
  }

  exec { "copy_hsqldb-${liquibase::hsqldb_version}.jar":
    command => "/bin/cp ${staging::path}/liquibase/hsqldb-${liquibase::hsqldb_version}.jar /opt/apps/liquibase/liquibase-${liquibase::version}/lib/",
    path    => '/usr/local/bin/:/bin/',
    creates => "/opt/apps/liquibase/liquibase-${liquibase::version}/lib/hsqldb-${liquibase::hsqldb_version}.jar",
    require => [Staging::Extract["liquibase-${liquibase::version}-bin.tar.gz"], Staging::File["hsqldb-${liquibase::hsqldb_version}.jar"]],
  }

  # Jtds
  staging::file { "jtds-${liquibase::jtds_version}.jar":
    environment => $liquibase::environment,
    source      => "http://central.maven.org/maven2/net/sourceforge/jtds/jtds/${liquibase::jtds_version}/jtds-${liquibase::jtds_version}.jar",
    require     => Staging::Extract["liquibase-${liquibase::version}-bin.tar.gz"],
  }

  exec { "copy_jtds-${liquibase::jtds_version}.jar":
    command => "/bin/cp ${staging::path}/liquibase/jtds-${liquibase::jtds_version}.jar /opt/apps/liquibase/liquibase-${liquibase::version}/lib/",
    path    => '/usr/local/bin/:/bin/',
    creates => "/opt/apps/liquibase/liquibase-${liquibase::version}/lib/jtds-${liquibase::jtds_version}.jar",
    require => [Staging::Extract["liquibase-${liquibase::version}-bin.tar.gz"], Staging::File["jtds-${liquibase::jtds_version}.jar"]],
  }

  # MySql
  staging::file { "mysql-connector-java-${liquibase::mysql_version}.jar":
    environment => $liquibase::environment,
    source      => "http://central.maven.org/maven2/mysql/mysql-connector-java/${liquibase::mysql_version}/mysql-connector-java-${liquibase::mysql_version}.jar",
    require     => Staging::Extract["liquibase-${liquibase::version}-bin.tar.gz"],
  }

  exec { "copy_mysql-connector-java-${liquibase::mysql_version}.jar":
    command => "/bin/cp ${staging::path}/liquibase/mysql-connector-java-${liquibase::mysql_version}.jar /opt/apps/liquibase/liquibase-${liquibase::version}/lib/",
    path    => '/usr/local/bin/:/bin/',
    creates => "/opt/apps/liquibase/liquibase-${liquibase::version}/lib/mysql-connector-java-${liquibase::mysql_version}.jar",
    require => [Staging::Extract["liquibase-${liquibase::version}-bin.tar.gz"], Staging::File["mysql-connector-java-${liquibase::mysql_version}.jar"]],
  }

  # Jt400
  staging::file { "jt400-${liquibase::jt400_version}.jar":
    environment => $liquibase::environment,
    source      => "http://central.maven.org/maven2/net/sf/jt400/jt400/${liquibase::jt400_version}/jt400-${liquibase::jt400_version}.jar",
    require     => Staging::Extract["liquibase-${liquibase::version}-bin.tar.gz"],
  }

  exec { "copy_jt400-${liquibase::jt400_version}.jar":
    command => "/bin/cp ${staging::path}/liquibase/jt400-${liquibase::jt400_version}.jar /opt/apps/liquibase/liquibase-${liquibase::version}/lib/",
    path    => '/usr/local/bin/:/bin/',
    creates => "/opt/apps/liquibase/liquibase-${liquibase::version}/lib/jt400-${liquibase::jt400_version}.jar",
    require => [Staging::Extract["liquibase-${liquibase::version}-bin.tar.gz"], Staging::File["jt400-${liquibase::jt400_version}.jar"]],
  }

  # MariaDB
  staging::file { "mariadb-${liquibase::mariadb_version}.jar":
    environment => $liquibase::environment,
    source      => "http://central.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/${liquibase::mariadb_version}/mariadb-java-client-${liquibase::mariadb_version}.jar",
    require     => Staging::Extract["liquibase-${liquibase::version}-bin.tar.gz"],
  }

  exec { "copy_mariadb-${liquibase::mariadb_version}.jar":
    command => "/bin/cp ${staging::path}/liquibase/mariadb-${liquibase::mariadb_version}.jar /opt/apps/liquibase/liquibase-${liquibase::version}/lib/",
    path    => '/usr/local/bin/:/bin/',
    creates => "/opt/apps/liquibase/liquibase-${liquibase::version}/lib/mariadb-${liquibase::mariadb_version}.jar",
    require => [Staging::Extract["liquibase-${liquibase::version}-bin.tar.gz"], Staging::File["mariadb-${liquibase::mariadb_version}.jar"]],
  }

  # Sqlite
  # Copie du jar car seule cette version (3.7.8) fonctionne
  file { "/opt/apps/liquibase/liquibase-${liquibase::version}/lib/sqlite-jdbc-${liquibase::sqlite_version}.jar":
    ensure  => present,
    owner   => root,
    group   => root,
    source  => "puppet:///modules/liquibase/sqlite-jdbc-${liquibase::sqlite_version}.jar",
    require => Staging::Extract["liquibase-${liquibase::version}-bin.tar.gz"],
  }

}
