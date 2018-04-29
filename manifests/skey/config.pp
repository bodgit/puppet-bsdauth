# @!visibility private
class bsdauth::skey::config {

  file { $::bsdauth::skey::directory:
    ensure => directory,
    owner  => 0,
    group  => 'auth',
    mode   => '1620',
  }
}
