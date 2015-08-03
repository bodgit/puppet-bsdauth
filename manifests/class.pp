#
define bsdauth::class (
  $capabilities,
  $order        = '10',
) {

  validate_array($capabilities)

  ::concat::fragment { $name:
    content => template('bsdauth/class.erb'),
    order   => $order,
    target  => '/etc/login.conf',
  }
}
