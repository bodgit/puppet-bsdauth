# Manages login classes.
#
# @example Declaring the class
#   include ::bsdauth
#
# @param build_db Whether to compile the optional `/etc/login.conf.db` for 
#   faster lookups.
# @param classes A hash of login classes to create using `::bsdauth::class`.
#
# @see puppet_classes::bsdauth::authpf ::bsdauth::authpf
# @see puppet_classes::bsdauth::bgpd ::bsdauth::bgpd
# @see puppet_classes::bsdauth::ldap ::bsdauth::ldap
# @see puppet_classes::bsdauth::pbuild ::bsdauth::pbuild
# @see puppet_classes::bsdauth::skey ::bsdauth::skey
# @see puppet_classes::bsdauth::unbound ::bsdauth::unbound
# @see puppet_defined_types::bsdauth::class ::bsdauth::class
class bsdauth (
  Boolean                         $build_db = $::bsdauth::params::build_db,
  Hash[String, Hash[String, Any]] $classes  = $::bsdauth::params::classes,
) inherits ::bsdauth::params {

  contain ::bsdauth::config
}
