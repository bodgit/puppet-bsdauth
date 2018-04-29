# Manages Yubikey profiles.
#
# @example Declaring the class
#   class { '::bsdauth':
#     classes => {
#       'auth-defaults' => {
#         'capabilities' => [
#           'auth=yubikey,passwd,skey',
#         ],
#         'order'        => '01',
#       },
#       ...
#     },
#   }
#   include ::bsdauth::yubikey
#
# @param directory
#
# @see puppet_classes::bsdauth ::bsdauth
# @see puppet_defined_types::bsdauth::yubikey::user ::bsdauth::yubikey::user
#
# @since 2.0.0
class bsdauth::yubikey (
  Stdlib::Absolutepath $directory = $::bsdauth::params::yubikey_directory,
) inherits ::bsdauth::params {

  if ! defined(Class['::bsdauth']) {
    fail('You must include the bsdauth base class before using the bsdauth::yubikey class')
  }

  contain ::bsdauth::yubikey::config
}
