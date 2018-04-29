# @!visibility private
class bsdauth::config {

  ::concat { '/etc/login.conf':
    owner => 0,
    group => 0,
    mode  => '0644',
    warn  => "# !!! Managed by Puppet !!!\n",
  }

  if $::bsdauth::build_db {
    exec { 'cap_mkdb /etc/login.conf':
      path        => $::path,
      refreshonly => true,
      subscribe   => ::Concat['/etc/login.conf'],
    }
  } else {
    file { '/etc/login.conf.db':
      ensure  => absent,
      require => ::Concat['/etc/login.conf'],
    }
  }

  $::bsdauth::classes.each |$resource, $attributes| {
    ::bsdauth::class { $resource:
      * => $attributes,
    }
  }
}
