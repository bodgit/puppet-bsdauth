#
class bsdauth::params {

  case $::osfamily {
    'OpenBSD': {
      $build_db = false
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.") # lint:ignore:80chars
    }
  }
}
