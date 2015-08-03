#
class bsdauth (
  $build_db = $::bsdauth::params::build_db,
) inherits ::bsdauth::params {

  validate_bool($build_db)

  include ::bsdauth::config

  anchor { 'bsdauth::begin': }
  anchor { 'bsdauth::end': }

  Anchor['bsdauth::begin'] -> Class['::bsdauth::config']
    -> Anchor['bsdauth::end']
}
