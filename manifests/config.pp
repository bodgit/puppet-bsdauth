#
class bsdauth::config {

  ::concat { '/etc/login.conf':
    owner => 0,
    group => 0,
    mode  => '0644',
    warn  => '# !!! Managed by Puppet !!!',
  }

  if $::bsdauth::build_db {
    exec { 'cap_mkdb /etc/login.conf':
      path        => ['/sbin', '/usr/sbin', '/bin', '/usr/bin'],
      refreshonly => true,
      subscribe   => ::Concat['/etc/login.conf'],
    }
  } else {
    file { '/etc/login.conf.db':
      ensure  => absent,
      require => ::Concat['/etc/login.conf'],
    }
  }

  $defaults = {
    'auth-defaults' => {
      'capabilities' => [
        'auth=passwd,skey',
      ],
      'order'        => '01',
    },
    'auth-ftp-defaults' => {
      'capabilities' => [
        'auth-ftp=passwd',
      ],
      'order'        => '02',
    },
    'default' => {
      'capabilities' => [
        'path=/usr/bin /bin /usr/sbin /sbin /usr/X11R6/bin /usr/local/bin /usr/local/sbin', # lint:ignore:80chars
        'umask=022',
        'datasize-max=512M',
        'datasize-cur=512M',
        'maxproc-max=256',
        'maxproc-cur=128',
        'openfiles-cur=512',
        'stacksize-cur=4M',
        'localcipher=blowfish,8',
        'ypcipher=old',
        'tc=auth-defaults',
        'tc=auth-ftp-defaults',
      ],
      'order'        => '03',
    },
    'daemon' => {
      'capabilities' => [
        'ignorenologin',
        'datasize=infinity',
        'maxproc=infinity',
        'openfiles-cur=128',
        'stacksize-cur=8M',
        'localcipher=blowfish,9',
        'tc=default',
      ],
      'order'        => '04',
    },
    'staff' => {
      'capabilities' => [
        'datasize-cur=1536M',
        'datasize-max=infinity',
        'maxproc-max=512',
        'maxproc-cur=256',
        'ignorenologin',
        'requirehome@',
        'tc=default',
      ],
      'order'        => '05',
    },
    # These should maybe become part of other classes
    'authpf' => {
      'capabilities' => [
        'welcome=/etc/motd.authpf',
        'shell=/usr/sbin/authpf',
        'tc=default',
      ],
      'order'        => '06',
    },
    'bgpd' => {
      'capabilities' => [
        'openfiles-cur=512',
        'tc=daemon',
      ],
      'order'        => '07',
    },
    'unbound' => {
      'capabilities' => [
        'openfiles-cur=512',
        'tc=daemon',
      ],
      'order'        => '08',
    },
  }

  create_resources(bsdauth::class, $defaults)
}
