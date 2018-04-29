require 'spec_helper_acceptance'

describe 'bsdauth' do

  pp = <<-EOS
    include ::bsdauth
    include ::bsdauth::authpf
    include ::bsdauth::bgpd
    include ::bsdauth::pbuild
    include ::bsdauth::unbound
  EOS

  case fact('osfamily')
  when 'OpenBSD'
    it 'should work with no errors' do
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe file('/etc/login.conf') do
      it { should be_file }
      it { should be_mode 644 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'wheel' }
      its(:size) { should > 0 }
    end

    describe file('/etc/login.conf.db') do
      it { should_not exist }
    end

    describe command('getcap -a -f /etc/login.conf') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /^auth-defaults:/ }
      its(:stdout) { should match /^auth-ftp-defaults:/ }
      its(:stdout) { should match /^default:/ }
      its(:stdout) { should match /^daemon:/ }
      its(:stdout) { should match /^staff:/ }
      its(:stdout) { should match /^authpf:/ }
      its(:stdout) { should match /^bgpd:/ }
      its(:stdout) { should match /^pbuild:/ }
      its(:stdout) { should match /^unbound:/ }
    end
  else
    it 'should not work' do
      apply_manifest(pp, :expect_failures => true)
    end
  end
end
