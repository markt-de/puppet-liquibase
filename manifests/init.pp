# @summary Install liquibase
#
# @example
#   include liquibase
#
# @param ensure
#   The Version of Liquibase Core. Default: 'present' ENUM('present','absent')
#
# @param version
#   The Version of Liquibase Core. Default: '4.7.1'
#
# @param mirror
#   The base URI from the REPO. Default: 'https://github.com'
#
# @param install_root
#   The base Path to install liquibase. Default: '/opt/apps'
#
# @param percona_version
#   The Version of Percona Plugin. Default: '4.7.0'
#
# @param mysql_version
#   The Version of MySQL JDBC Plugin. Default: '8.0.28'
#
# @param tmp_dir
#   The base Path to extract and prepare Plugins. Default: '/tmp/liquibase_plugins'
#
class liquibase(
  Enum['present', 'absent'] $ensure = $liquibase::ensure,
  String $version = $liquibase::version,
  String $mirror = $liquibase::mirror,
  Stdlib::Absolutepath $install_root = $liquibase::install_root,
  String $percona_version = $liquibase::percona_version,
  String $mysql_version = $liquibase::mysql_version,
  Stdlib::Absolutepath $tmp_dir = $liquibase::tmp_dir,
  ) {
  class {'liquibase::install': }
}
