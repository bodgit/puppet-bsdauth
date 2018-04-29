# Manages the authpf login class.
#
# @example Declaring the class
#   include ::bsdauth
#   include ::bsdauth::authpf
#
# @param attributes
#
# @see puppet_classes::bsdauth ::bsdauth
# @see puppet_defined_types::bsdauth::class ::bsdauth::class
#
# @since 2.0.0
class bsdauth::authpf (
  Hash[String, Any] $attributes = $::bsdauth::params::authpf_attributes,
) inherits ::bsdauth::params {

  if ! defined(Class['::bsdauth']) {
    fail('You must include the bsdauth base class before using the bsdauth::authpf class')
  }

  ::bsdauth::class { 'authpf':
    * => $attributes,
  }
}
