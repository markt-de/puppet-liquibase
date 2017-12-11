# See README.md
class liquibase(
  #version de liquibase
  $version            = $liquibase::version,
  # Versions des drivers jdbc
  $postgresql_version = $liquibase::postgresql_version,
  $derby_version      = $liquibase::derby_version,
  $h2_version         = $liquibase::h2_version,
  $hsqldb_version     = $liquibase::hsqldb_version,
  $jtds_version       = $liquibase::jtds_version,
  $mysql_version      = $liquibase::mysql_version,
  $sqlite_version     = $liquibase::sqlite_version,
  $jt400_version      = $liquibase::jt400_version,
  $mariadb_version    = $liquibase::mariadb_version,
  $environment        = $liquibase::environment,
  ) inherits liquibase::params {
  class {'liquibase::install': } -> Class['liquibase']
}
