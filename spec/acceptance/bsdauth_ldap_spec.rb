require 'spec_helper_acceptance'

describe 'bsdauth::ldap' do

  pp = <<-EOS
    Package {
      source => "http://ftp.openbsd.org/pub/OpenBSD/${::operatingsystemrelease}/packages/${::architecture}/",
    }

    include ::bsdauth
    include ::bsdauth::ldap

    ::bsdauth::ldap::class { 'ldap':
      base_dn => 'dc=example,dc=com',
      bind_dn => 'uid=test,ou=people,dc=example,dc=com',
      bind_pw => 'password',
      servers => [
        {
          'hostname' => '127.0.0.1',
        },
        {
          'hostname' => '192.0.2.1',
        },
        {
          'hostname' => '192.0.2.2',
          'mode'     => 'ssl',
        },
      ],
    }
  EOS

  case fact('osfamily')
  when 'OpenBSD'
    it 'should work with no errors' do
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe package('login_ldap') do
      it { should be_installed }
    end

    describe command('getcap -f /etc/login.conf ldap') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /^ldap:(\s+:)?auth=-ldap:(\s+:)?x-ldap-basedn=dc=example,dc=com:(\s+:)?x-ldap-binddn=uid=test,ou=people,dc=example,dc=com:(\s+:)?x-ldap-bindpw=password:(\s+:)?x-ldap-server=127.0.0.1:(\s+:)?x-ldap-serveralt0=192.0.2.1:(\s+:)?x-ldap-serveralt1=192.0.2.2,,ssl:/ }
    end
  else
    it 'should not work' do
      apply_manifest(pp, :expect_failures => true)
    end
  end
end
