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
# @param group_scope
# @param keep_credentials
# @param login_class The name of the login class.
# @param order The order of the class within `login.conf`.
# @param referrals
# @param styles The authentication styles to use.
# @param timeout
# @param tls_cacert_dir
# @param tls_cacert_file
# @param tls_cert
# @param tls_key
# @param user_filter The LDAP search filter to use when searching for users.
# @param user_scope
#
# @see puppet_classes::bsdauth::ldap ::bsdauth::ldap
# @see puppet_defined_types::bsdauth::class ::bsdauth::class
#
# @since 2.0.0
define bsdauth::ldap::class (
  Bodgitlib::LDAP::DN               $base_dn,
  Array[BSDAuth::LDAP::Server, 1]   $servers,
  Array[String]                     $attributes       = [
    'tc=default',
  ],
  Optional[Bodgitlib::LDAP::DN]     $bind_dn          = undef,
  Optional[String]                  $bind_pw          = undef,
  Optional[Bodgitlib::LDAP::DN]     $group_dn         = undef,
  Optional[Bodgitlib::LDAP::Filter] $group_filter     = undef,
  Optional[Bodgitlib::LDAP::Scope]  $group_scope      = undef,
  Optional[Boolean]                 $keep_credentials = undef,
  String                            $login_class      = $title,
  Variant[String, Integer[0]]       $order            = '10',
  Optional[Boolean]                 $referrals        = undef,
  Array[String, 1]                  $styles           = [
    '-ldap',
  ],
  Optional[Integer[0, 300]]         $timeout          = undef,
  Optional[Stdlib::Absolutepath]    $tls_cacert_dir   = undef,
  Optional[Stdlib::Absolutepath]    $tls_cacert_file  = undef,
  Optional[Stdlib::Absolutepath]    $tls_cert         = undef,
  Optional[Stdlib::Absolutepath]    $tls_key          = undef,
  Optional[Bodgitlib::LDAP::Filter] $user_filter      = undef,
  Optional[Bodgitlib::LDAP::Scope]  $user_scope       = undef,
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
    'x-ldap-cacertdir'   => $tls_cacert_dir,
    'x-ldap-cacert'      => $tls_cacert_file,
    'x-ldap-groupdn'     => $group_dn,
    'x-ldap-groupfilter' => $group_filter,
    'x-ldap-gscope'      => $group_scope,
    'x-ldap-filter'      => $user_filter,
    'x-ldap-timeout'     => $timeout,
    'x-ldap-uscope'      => $user_scope,
    'x-ldap-usercert'    => $tls_cert,
    'x-ldap-userkey'     => $tls_key,
  }), '='), delete_undef_values([
    $referrals ? {
      false   => 'x-ldap-noreferrals',
      default => undef,
    },
    $keep_credentials ? {
      true    => 'x-ldap-refkeepcreds',
      default => undef,
    },
  ]), $_servers, $attributes])

  ::bsdauth::class { $login_class:
    capabilities => $capabilities,
    order        => $order,
  }
}
