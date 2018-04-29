require 'spec_helper'

describe 'bsdauth' do

  on_supported_os.each do |os, facts|
    context "on #{os}", :compile do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
        })
      end

      it { should contain_bsdauth__class('auth-defaults') }
      it { should contain_bsdauth__class('auth-ftp-defaults') }
      it { should contain_bsdauth__class('daemon') }
      it { should contain_bsdauth__class('default') }
      it { should contain_bsdauth__class('staff') }
      it { should contain_class('bsdauth') }
      it { should contain_class('bsdauth::config') }
      it { should contain_class('bsdauth::params') }
      it { should contain_concat('/etc/login.conf') }
      it { should contain_concat__fragment('bsdauth auth-defaults').with_content(<<-'EOS'.gsub(/^ {8}/, ''))
        auth-defaults:\
        	:auth=passwd,skey:
        EOS
      }
      it { should contain_concat__fragment('bsdauth auth-ftp-defaults').with_content(<<-'EOS'.gsub(/^ {8}/, ''))
        auth-ftp-defaults:\
        	:auth-ftp=passwd:
        EOS
      }
      it { should contain_concat__fragment('bsdauth daemon').with_content(<<-'EOS'.gsub(/^ {8}/, ''))
        daemon:\
        	:ignorenologin:\
        	:datasize=infinity:\
        	:maxproc=infinity:\
        	:openfiles-max=1024:\
        	:openfiles-cur=128:\
        	:stacksize-cur=8M:\
        	:localcipher=blowfish,a:\
        	:tc=default:
        EOS
      }
      it { should contain_concat__fragment('bsdauth default').with_content(<<-'EOS'.gsub(/^ {8}/, ''))
        default:\
        	:path=/usr/bin /bin /usr/sbin /sbin /usr/X11R6/bin /usr/local/bin /usr/local/sbin:\
        	:umask=022:\
        	:datasize-max=768M:\
        	:datasize-cur=768M:\
        	:maxproc-max=256:\
        	:maxproc-cur=128:\
        	:openfiles-max=1024:\
        	:openfiles-cur=512:\
        	:stacksize-cur=4M:\
        	:localcipher=blowfish,a:\
        	:tc=auth-defaults:\
        	:tc=auth-ftp-defaults:
        EOS
      }
      it { should contain_concat__fragment('bsdauth staff').with_content(<<-'EOS'.gsub(/^ {8}/, ''))
        staff:\
        	:datasize-cur=1536M:\
        	:datasize-max=infinity:\
        	:maxproc-max=512:\
        	:maxproc-cur=256:\
        	:ignorenologin:\
        	:requirehome@:\
        	:tc=default:
        EOS
      }
      it { should_not contain_exec('cap_mkdb /etc/login.conf') }
      it { should contain_file('/etc/login.conf.db').with_ensure('absent') }
    end
  end
end
