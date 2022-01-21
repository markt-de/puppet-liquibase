# @summary Install packages, setup for liquibase.
class liquibase::install {
  # See README.md
  include 'archive'

  $tmp_dir = $liquibase::tmp_dir
  $ensure_directory = $liquibase::ensure ? { 'present' => 'directory', default => 'absent' }
  $ensure_link = $liquibase::ensure ? { 'present' => 'link', default => 'absent' }
  $ensure_present = $liquibase::ensure ? { 'present' => 'present', default => 'absent' }
  file { $tmp_dir:
    ensure  => $ensure_directory,
    recurse => true,
  }
  #
  # Liquibase
  #
  $dist_dir = "liquibase-${liquibase::version}"
  $archive_name = "${dist_dir}.tar.gz"
  $install_dir = "${liquibase::install_root}/${dist_dir}"
  file { $liquibase::install_root:
    ensure  => $ensure_directory,
    recurse => true,
  }
  file { $install_dir:
    ensure  => $ensure_directory,
    recurse => true,
    force   => true,
  }
  archive { "${liquibase::install_root}/${archive_name}":
    ensure       => $ensure_present,
    source       => "${liquibase::mirror}/liquibase/liquibase/releases/download/v${liquibase::version}/${$archive_name}",
    extract      => true,
    extract_path => $install_dir,
    creates      => "${liquibase::install_root}/liquibase",
    cleanup      => false,
  }
  file { "${liquibase::install_root}/liquibase":
    ensure => $ensure_link,
    target => $install_dir,
  }
  #
  # Percona Plugin
  #
  $percona_path = "/liquibase-percona/releases/download/liquibase-percona-${liquibase::percona_version}"
  $percona_jar = "liquibase-percona-${liquibase::percona_version}.jar"
  archive { "${install_dir}/lib/${percona_jar}":
    ensure  => $ensure_present,
    source  => "${liquibase::mirror}/liquibase${percona_path}/${percona_jar}",
    cleanup => false,
  }
  #
  # Mysql Plugin
  #
  $mysql_name = "mysql-connector-java-${liquibase::mysql_version}"
  $mysql_jar  = "${mysql_name}.jar"
  archive { "${tmp_dir}/${mysql_name}.tar.gz":
    ensure       => $ensure_present,
    source       => "https://dev.mysql.com/get/Downloads/Connector-J/${mysql_name}.tar.gz",
    extract      => true,
    creates      => "${tmp_dir}/mysql-plugin",
    extract_path => $tmp_dir,
    cleanup      => false,
  }
  file { "${install_dir}/lib/${mysql_jar}":
    ensure => $ensure_present,
    source => "${tmp_dir}/${mysql_name}/${mysql_jar}",
  }
}
