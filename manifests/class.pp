# Define a login class.
#
# @example Declaring a login class
#   include ::bsdauth
#   ::bsdauth::class { 'example':
#     capabilities => [
#       'auth=yubikey,passwd,skey',
#       'tc=auth-defaults',
#     ],
#   }
#
# @param capabilities The list of capabilities defined by the login class.
# @param class The name of the login class.
# @param order The order of the class within `login.conf`.
#
# @see puppet_classes::bsdauth ::bsdauth
define bsdauth::class (
  Array[String, 1]            $capabilities,
  String                      $class        = $title,
  Variant[String, Integer[0]] $order        = '10',
) {

  ::concat::fragment { "${module_name} ${class}":
    content => template("${module_name}/class.erb"),
    order   => $order,
    target  => '/etc/login.conf',
  }
}
