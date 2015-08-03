#
class bsdauth::ldap (
  $base_dn,
  $servers,
  $bind_dn      = undef,
  $bind_pw      = undef,
  $group_dn     = undef,
  $group_filter = undef,
  $login_class  = 'ldap',
  $user_filter  = '(&(objectclass=posixAccount)(uid=%u))',
) inherits ::bsdauth::params {

  if ! defined(Class['::bsdauth']) {
    fail('You must include the bsdauth base class before using the bsdauth::ldap class ') # lint:ignore:80chars
  }

  validate_string($base_dn)
  if $bind_dn {
    validate_string($bind_dn)
  }
  if $bind_pw {
    validate_string($bind_pw)
  }
  if $group_dn {
    validate_string($group_dn)
  }
  if $group_filter {
    validate_string($group_filter)
  }
  validate_array($servers)
  validate_string($user_filter)

  include ::bsdauth::ldap::install
  include ::bsdauth::ldap::config

  anchor { 'bsdauth::ldap::begin': }
  anchor { 'bsdauth::ldap::end': }

  Anchor['bsdauth::ldap::begin'] -> Class['::bsdauth::ldap::install']
    -> Class['::bsdauth::ldap::config'] -> Anchor['bsdauth::ldap::end']
}
