#
class bsdauth::ldap::config {

  $servers = ldap_uri_to_login_ldap($::bsdauth::ldap::servers, false)

  $capabilities = flatten([join_keys_to_values(delete_undef_values({
    'auth'               => '-ldap',
    'x-ldap-basedn'      => $::bsdauth::ldap::base_dn,
    'x-ldap-binddn'      => $::bsdauth::ldap::bind_dn,
    'x-ldap-bindpw'      => $::bsdauth::ldap::bind_pw,
    'x-ldap-groupdn'     => $::bsdauth::ldap::group_dn,
    'x-ldap-groupfilter' => $::bsdauth::ldap::group_filter,
    'x-ldap-filter'      => $::bsdauth::ldap::user_filter,
  }), '='), $servers, 'tc=default'])

  ::bsdauth::class { $::bsdauth::ldap::login_class:
    capabilities => $capabilities,
  }
}
