# Manages S/Key profiles.
#
# @example Declaring the class
#   include ::bsdauth
#   include ::bsdauth::skey
#
# @param directory
#
# @see puppet_classes::bsdauth ::bsdauth
#
# @since 2.0.0
class bsdauth::skey (
  Stdlib::Absolutepath $directory = $::bsdauth::params::skey_directory,
) inherits ::bsdauth::params {

  if ! defined(Class['::bsdauth']) {
    fail('You must include the bsdauth base class before using the bsdauth::skey class')
  }

  contain ::bsdauth::skey::config
}
