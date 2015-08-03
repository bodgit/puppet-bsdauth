#
class bsdauth::ldap::config {

  $servers = $::bsdauth::ldap::servers

  if size($servers) > 1 {
    $alternates = prefix(range(0, size($servers) - 2), 'x-ldap-serveralt')
    $variables = flatten(['x-ldap-server', $alternates])
  } else {
    $variables = ['x-ldap-server']
  }

  # Holy nested Puppet functions Batman!
  $capabilities = join_keys_to_values(merge(delete_undef_values({
    'auth'               => '-ldap',
    'x-ldap-basedn'      => $::bsdauth::ldap::base_dn,
    'x-ldap-binddn'      => $::bsdauth::ldap::bind_dn,
    'x-ldap-bindpw'      => $::bsdauth::ldap::bind_pw,
    'x-ldap-groupdn'     => $::bsdauth::ldap::group_dn,
    'x-ldap-groupfilter' => $::bsdauth::ldap::group_filter,
    'x-ldap-filter'      => $::bsdauth::ldap::user_filter,
  }), hash(flatten(zip($variables, $servers))), { 'tc' => 'default' }), '=')

  ::bsdauth::class { $::bsdauth::ldap::login_class:
    capabilities => $capabilities,
  }
}
