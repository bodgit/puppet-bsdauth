# Manages LDAP login classes.
#
# @example Declaring the class
#   include ::bsdauth
#   include ::bsdauth::ldap
#
# @param classes A hash of LDAP login classes to create using
#   `::bsdauth::ldap::class`.
# @param package_name The package name.
#
# @see puppet_classes::bsdauth ::bsdauth
# @see puppet_defined_types::bsdauth::ldap::class ::bsdauth::ldap::class
class bsdauth::ldap (
  Hash[String, Hash[String, Any]] $classes      = {},
  String                          $package_name = $::bsdauth::params::ldap_package_name,
) inherits ::bsdauth::params {

  if ! defined(Class['::bsdauth']) {
    fail('You must include the bsdauth base class before using the bsdauth::ldap class')
  }

  contain ::bsdauth::ldap::install
  contain ::bsdauth::ldap::config

  Class['::bsdauth::ldap::install'] -> Class['::bsdauth::ldap::config']
}
