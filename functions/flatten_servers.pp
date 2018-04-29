# Flatten an array of LDAP servers to an array of strings.
#
# @param servers The array of servers to flatten.
#
# @return [Array[String, 1]] The array of flattened servers.
#
# @example
#   bsdauth::flatten_servers([{'hostname' => '192.0.2.1'}])
#
# @since 2.0.0
function bsdauth::flatten_servers(Array[BSDAuth::LDAP::Server, 1] $servers) {

  $servers.map |Integer $i, BSDAuth::LDAP::Server $server| {

    $prefix = $i ? {
      0       => 'x-ldap-server',
      default => "x-ldap-serveralt${$i - 1}",
    }

    # Strip off any trailing commas thanks to optional values
    regsubst("${prefix}=${server[hostname]},${server[port]},${server[mode]},${server[version]}", ',+$', '')
  }
}
