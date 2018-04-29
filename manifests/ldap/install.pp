# @!visibility private
class bsdauth::ldap::install {

  package { $::bsdauth::ldap::package_name:
    ensure => present,
  }
}
