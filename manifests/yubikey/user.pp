# Managing a Yubikey device for login purposes.
#
# @example Declaring a Yubikey device for a user
#   include ::bsdauth
#   include ::bsdauth::yubikey
#   ::bsdauth::yubikey { 'user':
#     key => 'deadbeefcafebabec0ffee0123456789',
#     uid => 'cafedeadbeef',
#   }
#
# @param key The key from the given Yubikey.
# @param uid The uid from the given Yubikey.
# @param user The username the owns the Yubikey.
#
# @see puppet_classes::bsdauth::yubikey ::bsdauth::yubikey
#
# @since 2.0.0
define bsdauth::yubikey::user (
  Pattern[/^[0-9a-f]{32}$/] $key,
  Pattern[/^[0-9a-f]{12}$/] $uid,
  String                    $user = $title,
) {

  if ! defined(Class['::bsdauth::yubikey']) {
    fail('You must include the bsdauth::yubikey base class before using any bsdauth::yubikey defined resources')
  }

  $directory = $::bsdauth::yubikey::directory

  file { "${directory}/${user}.uid":
    ensure  => file,
    owner   => 0,
    group   => 'auth',
    mode    => '0440',
    content => "${uid}\n",
  }

  file { "${directory}/${user}.key":
    ensure  => file,
    owner   => 0,
    group   => 'auth',
    mode    => '0440',
    content => "${key}\n",
  }

  file { "${directory}/${user}.ctr":
    ensure  => file,
    owner   => 0,
    group   => 'auth',
    mode    => '0440',
    content => "0\n",
    replace => false,
  }
}
