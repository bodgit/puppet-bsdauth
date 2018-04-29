# @!visibility private
class bsdauth::yubikey::config {

  file { $::bsdauth::yubikey::directory:
    ensure       => directory,
    owner        => 0,
    group        => 'auth',
    mode         => '0660',
    purge        => true,
    recurse      => true,
    recurselimit => 1,
  }
}
