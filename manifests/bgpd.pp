# Managed the bgpd login class.
#
# @example Declaring the class
#   include ::bsdauth
#   include ::bsdauth::bgpd
#
# @param attributes
#
# @see puppet_classes::bsdauth ::bsdauth
# @see puppet_defined_types::bsdauth::class ::bsdauth::class
#
# @since 2.0.0
class bsdauth::bgpd (
  Hash[String, Any] $attributes = $::bsdauth::params::bgpd_attributes,
) inherits ::bsdauth::params {

  if ! defined(Class['::bsdauth']) {
    fail('You must include the bsdauth base class before using the bsdauth::bgpd class')
  }

  ::bsdauth::class { 'bgpd':
    * => $attributes,
  }
}
