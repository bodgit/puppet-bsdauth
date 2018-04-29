# @!visibility private
class bsdauth::ldap::config {

  $::bsdauth::ldap::classes.each |$resource, $attributes| {
    ::bsdauth::ldap::class { $resource:
      * => $attributes,
    }
  }
}
