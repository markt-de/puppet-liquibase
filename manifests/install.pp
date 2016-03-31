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

  staging::file { "liquibase-${::version}-bin.tar.gz":
    environment => $environment,
    source      => "https://github.com/liquibase/liquibase/releases/download/liquibase-parent-${::version}/liquibase-${::version}-bin.tar.gz",
  }

  file { '/opt/apps/liquibase/':
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
    require => Staging::File["liquibase-${::version}-bin.tar.gz"],
  }

  file { "/opt/apps/liquibase/liquibase-${::version}":
    ensure  => directory,
    require => Staging::File["liquibase-${::version}-bin.tar.gz"],
  }

  staging::extract { "liquibase-${::version}-bin.tar.gz":
    target  => "/opt/apps/liquibase/liquibase-${::version}",
    require => Staging::File["liquibase-${::version}-bin.tar.gz"],
  }

  # Creation des liens synboliques
  file { '/opt/liquibase':
    ensure => 'link',
    target => "/opt/apps/liquibase/liquibase-${::version}",
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
    require => Staging::Extract["liquibase-${::version}-bin.tar.gz"],
  }

  # Copie des drivers
  # PostgreSQL
  staging::file { "postgresql-${::postgresql_version}.jar":
    environment => $environment,
    source      => "http://central.maven.org/maven2/org/postgresql/postgresql/${::postgresql_version}/postgresql-${::postgresql_version}.jar",
    require     => Staging::Extract["liquibase-${::version}-bin.tar.gz"],
  }

  exec { "copy_postgresql-${postgresql_version}.jar":
    command => "/bin/cp ${::staging::path}/liquibase/postgresql-${::postgresql_version}.jar /opt/apps/liquibase/liquibase-${::version}/lib/",
    path    => '/usr/local/bin/:/bin/',
    creates => "/opt/liquibase-${::version}/lib/postgresql-${::postgresql_version}.jar",
    require => [Staging::Extract["liquibase-${::version}-bin.tar.gz"], Staging::File["postgresql-${::postgresql_version}.jar"]]
  }

  # Derby
  staging::file { "derbyclient-${::derby_version}.jar":
    environment => $environment,
    source      => "http://central.maven.org/maven2/org/apache/derby/derbyclient/${::derby_version}/derbyclient-${::derby_version}.jar",
    require     => Staging::Extract["liquibase-${::version}-bin.tar.gz"],
  }

  exec { "copy_derbyclient-${derby_version}.jar":
    command => "/bin/cp ${::staging::path}/liquibase/derbyclient-${::derby_version}.jar /opt/apps/liquibase/liquibase-${::version}/lib/",
    path    => '/usr/local/bin/:/bin/',
    creates => "/opt/apps/liquibase/liquibase-${::version}/lib/derbyclient-${::derby_version}.jar",
    require => [Staging::Extract["liquibase-${::version}-bin.tar.gz"], Staging::File["derbyclient-${::derby_version}.jar"]],
  }

  # H2
  staging::file { "h2-${::h2_version}.jar":
    environment => $environment,
    source      => "http://central.maven.org/maven2/com/h2database/h2/${::h2_version}/h2-${::h2_version}.jar",
    require     => Staging::Extract["liquibase-${::version}-bin.tar.gz"],
  }

  exec { "copy_h2-${h2_version}.jar":
    command => "/bin/cp ${::staging::path}/liquibase/h2-${::h2_version}.jar /opt/apps/liquibase/liquibase-${::version}/lib/",
    path    => '/usr/local/bin/:/bin/',
    creates => "/opt/apps/liquibase/liquibase-${::version}/lib/h2-${::h2_version}.jar",
    require => [Staging::Extract["liquibase-${::version}-bin.tar.gz"], Staging::File["h2-${::h2_version}.jar"]],
  }

  # Hsqldb
  staging::file { "hsqldb-${::hsqldb_version}.jar":
    environment => $environment,
    source      => "http://central.maven.org/maven2/org/hsqldb/hsqldb/${::hsqldb_version}/hsqldb-${::hsqldb_version}.jar",
    require     => Staging::Extract["liquibase-${::version}-bin.tar.gz"],
  }

  exec { "copy_hsqldb-${hsqldb_version}.jar":
    command => "/bin/cp ${::staging::path}/liquibase/hsqldb-${::hsqldb_version}.jar /opt/apps/liquibase/liquibase-${::version}/lib/",
    path    => '/usr/local/bin/:/bin/',
    creates => "/opt/apps/liquibase/liquibase-${::version}/lib/hsqldb-${::hsqldb_version}.jar",
    require => [Staging::Extract["liquibase-${::version}-bin.tar.gz"], Staging::File["hsqldb-${::hsqldb_version}.jar"]],
  }

  # Jtds
  staging::file { "jtds-${::jtds_version}.jar":
    environment => $environment,
    source      => "http://central.maven.org/maven2/net/sourceforge/jtds/jtds/${::jtds_version}/jtds-${::jtds_version}.jar",
    require     => Staging::Extract["liquibase-${::version}-bin.tar.gz"],
  }

  exec { "copy_jtds-${jtds_version}.jar":
    command => "/bin/cp ${::staging::path}/liquibase/jtds-${::jtds_version}.jar /opt/apps/liquibase/liquibase-${::version}/lib/",
    path    => '/usr/local/bin/:/bin/',
    creates => "/opt/apps/liquibase/liquibase-${::version}/lib/jtds-${::jtds_version}.jar",
    require => [Staging::Extract["liquibase-${::version}-bin.tar.gz"], Staging::File["jtds-${::jtds_version}.jar"]],
  }

  # MySql
  staging::file { "mysql-connector-java-${::mysql_version}.jar":
    environment => $environment,
    source      => "http://central.maven.org/maven2/mysql/mysql-connector-java/${::mysql_version}/mysql-connector-java-${::mysql_version}.jar",
    require     => Staging::Extract["liquibase-${::version}-bin.tar.gz"],
  }

  exec { "copy_mysql-connector-java-${mysql_version}.jar":
    command => "/bin/cp ${::staging::path}/liquibase/mysql-connector-java-${::mysql_version}.jar /opt/apps/liquibase/liquibase-${::version}/lib/",
    path    => '/usr/local/bin/:/bin/',
    creates => "/opt/apps/liquibase/liquibase-${::version}/lib/mysql-connector-java-${::mysql_version}.jar",
    require => [Staging::Extract["liquibase-${::version}-bin.tar.gz"], Staging::File["mysql-connector-java-${::mysql_version}.jar"]],
  }

  # Jt400
  staging::file { "jt400-${::jt400_version}.jar":
    environment => $environment,
    source      => "http://central.maven.org/maven2/net/sf/jt400/jt400/${::jt400_version}/jt400-${::jt400_version}.jar",
    require     => Staging::Extract["liquibase-${::version}-bin.tar.gz"],
  }

  exec { "copy_jt400-${jt400_version}.jar":
    command => "/bin/cp ${::staging::path}/liquibase/jt400-${::jt400_version}.jar /opt/apps/liquibase/liquibase-${::version}/lib/",
    path    => '/usr/local/bin/:/bin/',
    creates => "/opt/apps/liquibase/liquibase-${::version}/lib/jt400-${::jt400_version}.jar",
    require => [Staging::Extract["liquibase-${::version}-bin.tar.gz"], Staging::File["jt400-${::jt400_version}.jar"]],
  }

  # Sqlite
  # Copie du jar car seule cette version (3.7.8) fonctionne
  file { "/opt/apps/liquibase/liquibase-${::version}/lib/sqlite-jdbc-${sqlite_version}.jar":
    ensure  => present,
    owner   => root,
    group   => root,
    source  => "puppet:///modules/liquibase/sqlite-jdbc-${::sqlite_version}.jar",
    require => Staging::Extract["liquibase-${::version}-bin.tar.gz"],
  }

}
