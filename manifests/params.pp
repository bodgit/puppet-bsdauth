# @!visibility private
class bsdauth::params {

  case $::osfamily {
    'OpenBSD': {
      $build_db           = false
      $datasize           = $::architecture ? {
        'amd64' => '768',
        default => '512',
      }
      $classes            = {
        'auth-defaults'     => {
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
        'default'           => {
          'capabilities' => [
            'path=/usr/bin /bin /usr/sbin /sbin /usr/X11R6/bin /usr/local/bin /usr/local/sbin',
            'umask=022',
            "datasize-max=${datasize}M",
            "datasize-cur=${datasize}M",
            'maxproc-max=256',
            'maxproc-cur=128',
            'openfiles-max=1024',
            'openfiles-cur=512',
            'stacksize-cur=4M',
            'localcipher=blowfish,a',
            'tc=auth-defaults',
            'tc=auth-ftp-defaults',
          ],
          'order'        => '03',
        },
        'daemon'            => {
          'capabilities' => [
            'ignorenologin',
            'datasize=infinity',
            'maxproc=infinity',
            'openfiles-max=1024',
            'openfiles-cur=128',
            'stacksize-cur=8M',
            'localcipher=blowfish,a',
            'tc=default',
          ],
          'order'        => '04',
        },
        'staff'             => {
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
      }
      $authpf_attributes  = {
        'capabilities' => [
          'welcome=/etc/motd.authpf',
          'shell=/usr/sbin/authpf',
          'tc=default',
        ],
        'order'        => '06',
      }
      $pbuild_attributes  = {
        'capabilities' => [
          'datasize-max=infinity',
          'datasize-cur=4096M',
          'maxproc-max=1024',
          'maxproc-cur=256',
          'tc=default',
        ],
        'order'        => '07',
      }
      $bgpd_attributes    = {
        'capabilities' => [
          'openfiles=512',
          'tc=daemon',
        ],
        'order'        => '08',
      }
      $unbound_attributes = {
        'capabilities' => [
          'openfiles=512',
          'tc=daemon',
        ],
        'order'        => '09',
      }
      $ldap_package_name  = 'login_ldap'
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
}
