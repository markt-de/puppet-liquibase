# See README.md
class liquibase(
  #version de liquibase
  $version 	          =  $liquibase::params::version,
  # Versions des drivers jdbc
  $postgresql_version = $liquibase::params::postgresql_version,
  $derby_version      = $liquibase::params::derby_version,
  $h2_version         = $liquibase::params::h2_version,
  $hsqldb_version     = $liquibase::params::hsqldb_version,
  $jtds_version       = $liquibase::params::jtds_version,
  $mysql_version      = $liquibase::params::mysql_version,
  $sqlite_version     = $liquibase::params::sqlite_version,
  $jt400_version      = $liquibase::params::jt400_version,
  $environment        = hiera('environment'),
  ) inherits liquibase::params {

 class {'liquibase::install': } -> Class["liquibase"]

}
