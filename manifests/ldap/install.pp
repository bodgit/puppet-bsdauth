#
class bsdauth::ldap::install {

  package { 'login_ldap':
    ensure => present,
  }
}
