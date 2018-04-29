require 'spec_helper'

describe 'bsdauth::authpf' do

  let(:pre_condition) do
    'include ::bsdauth'
  end

  on_supported_os.each do |os, facts|
    context "on #{os}", :compile do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
        })
      end

      it { should contain_bsdauth__class('authpf') }
      it { should contain_class('bsdauth::authpf') }
      it { should contain_concat__fragment('bsdauth authpf').with_content(<<-'EOS'.gsub(/^ {8}/, ''))
        authpf:\
        	:welcome=/etc/motd.authpf:\
        	:shell=/usr/sbin/authpf:\
        	:tc=default:
        EOS
      }
    end
  end
end
