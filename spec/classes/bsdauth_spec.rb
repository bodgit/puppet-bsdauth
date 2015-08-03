require 'spec_helper'

describe 'bsdauth' do

  on_supported_os.each do |os, facts|
    context "on #{os}", :compile do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
        })
      end

      it { should contain_anchor('bsdauth::begin') }
      it { should contain_anchor('bsdauth::end') }
      it { should contain_bsdauth__class('authpf') }
      it { should contain_bsdauth__class('auth-defaults') }
      it { should contain_bsdauth__class('auth-ftp-defaults') }
      it { should contain_bsdauth__class('bgpd') }
      it { should contain_bsdauth__class('daemon') }
      it { should contain_bsdauth__class('default') }
      it { should contain_bsdauth__class('staff') }
      it { should contain_bsdauth__class('unbound') }
      it { should contain_class('bsdauth') }
      it { should contain_class('bsdauth::config') }
      it { should contain_class('bsdauth::params') }
      it { should contain_concat('/etc/login.conf') }
      it { should contain_concat__fragment('authpf').with_content(<<-EOS.gsub(/^ +/, ''))
        authpf:\\
        	:welcome=/etc/motd.authpf:\\
        	:shell=/usr/sbin/authpf:\\
        	:tc=default:
        EOS
      }
      it { should contain_concat__fragment('auth-defaults').with_content(<<-EOS.gsub(/^ +/, ''))
        auth-defaults:\\
        	:auth=passwd,skey:
        EOS
      }
      it { should contain_concat__fragment('auth-ftp-defaults').with_content(<<-EOS.gsub(/^ +/, ''))
        auth-ftp-defaults:\\
        	:auth-ftp=passwd:
        EOS
      }
      it { should contain_concat__fragment('bgpd').with_content(<<-EOS.gsub(/^ +/, ''))
        bgpd:\\
        	:openfiles-cur=512:\\
        	:tc=daemon:
        EOS
      }
      it { should contain_concat__fragment('daemon').with_content(<<-EOS.gsub(/^ +/, ''))
        daemon:\\
        	:ignorenologin:\\
        	:datasize=infinity:\\
        	:maxproc=infinity:\\
        	:openfiles-cur=128:\\
        	:stacksize-cur=8M:\\
        	:localcipher=blowfish,9:\\
        	:tc=default:
        EOS
      }
      it { should contain_concat__fragment('default').with_content(<<-EOS.gsub(/^ +/, ''))
        default:\\
        	:path=/usr/bin /bin /usr/sbin /sbin /usr/X11R6/bin /usr/local/bin /usr/local/sbin:\\
        	:umask=022:\\
        	:datasize-max=512M:\\
        	:datasize-cur=512M:\\
        	:maxproc-max=256:\\
        	:maxproc-cur=128:\\
        	:openfiles-cur=512:\\
        	:stacksize-cur=4M:\\
        	:localcipher=blowfish,8:\\
        	:ypcipher=old:\\
        	:tc=auth-defaults:\\
        	:tc=auth-ftp-defaults:
        EOS
      }
      it { should contain_concat__fragment('staff').with_content(<<-EOS.gsub(/^ +/, ''))
        staff:\\
        	:datasize-cur=1536M:\\
        	:datasize-max=infinity:\\
        	:maxproc-max=512:\\
        	:maxproc-cur=256:\\
        	:ignorenologin:\\
        	:requirehome@:\\
        	:tc=default:
        EOS
      }
      it { should contain_concat__fragment('unbound').with_content(<<-EOS.gsub(/^ +/, ''))
        unbound:\\
        	:openfiles-cur=512:\\
        	:tc=daemon:
        EOS
      }
      it { should_not contain_exec('cap_mkdb /etc/login.conf') }
      it { should contain_file('/etc/login.conf.db').with_ensure('absent') }
    end
  end
end
