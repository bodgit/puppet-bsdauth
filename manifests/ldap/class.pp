# Define an LDAP login class.
#
# @example Declaring an LDAP login class
#   include ::bsdauth
#   include ::bsdauth::ldap
#   ::bsdauth::ldap::class { 'ldap':
#     base_dn => 'dc=example,dc=com',
#     servers => [
#       {
#         hostname => '192.0.2.1',
#       },
#     ],
#   }
#
# @param base_dn The base DN from which to perform all LDAP queries.
# @param servers A list of LDAP servers to use.
# @param attributes A list of additional capabilities to append to the class
#   definition.
# @param bind_dn The Distinguished Name to use to bind to the LDAP servers.
# @param bind_pw The password to use when binding to the LDAP servers.
# @param group_dn The base DN from which to perform group LDAP queries, if
#   different from `base_dn`.
# @param group_filter The LDAP search filter to use when testing for group
#   membership.
# @param login_class The name of the login class.
# @param order The order of the class within `login.conf`.
# @param styles The authentication styles to use.
# @param user_filter The LDAP search filter to use when searching for users.
#
# @see puppet_classes::bsdauth::ldap ::bsdauth::ldap
# @see puppet_defined_types::bsdauth::class ::bsdauth::class
#
# @since 2.0.0
define bsdauth::ldap::class (
  Bodgitlib::LDAP::DN               $base_dn,
  Array[BSDAuth::LDAP::Server, 1]   $servers,
  Array[String]                     $attributes   = [
    'tc=default',
  ],
  Optional[Bodgitlib::LDAP::DN]     $bind_dn      = undef,
  Optional[String]                  $bind_pw      = undef,
  Optional[Bodgitlib::LDAP::DN]     $group_dn     = undef,
  Optional[Bodgitlib::LDAP::Filter] $group_filter = undef,
  String                            $login_class  = $title,
  Variant[String, Integer[0]]       $order        = '10',
  Array[String, 1]                  $styles       = [
    '-ldap',
  ],
  Optional[Bodgitlib::LDAP::Filter] $user_filter  = undef,
) {

  if ! defined(Class['::bsdauth::ldap']) {
    fail('You must include the bsdauth::ldap base class before using any bsdauth::ldap defined resources')
  }

  $_servers = bsdauth::flatten_servers($servers)

  $capabilities = flatten([join_keys_to_values(delete_undef_values({
    'auth'               => join($styles, ','),
    'x-ldap-basedn'      => $base_dn,
    'x-ldap-binddn'      => $bind_dn,
    'x-ldap-bindpw'      => $bind_pw,
    'x-ldap-groupdn'     => $group_dn,
    'x-ldap-groupfilter' => $group_filter,
    'x-ldap-filter'      => $user_filter,
  }), '='), $_servers, $attributes])

  ::bsdauth::class { $login_class:
    capabilities => $capabilities,
    order        => $order,
  }
}
