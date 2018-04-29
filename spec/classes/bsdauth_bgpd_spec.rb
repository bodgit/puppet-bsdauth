require 'spec_helper'

describe 'bsdauth::bgpd' do

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

      it { should contain_bsdauth__class('bgpd') }
      it { should contain_class('bsdauth::bgpd') }
      it { should contain_concat__fragment('bsdauth bgpd').with_content(<<-'EOS'.gsub(/^ {8}/, ''))
        bgpd:\
        	:openfiles=512:\
        	:tc=daemon:
        EOS
      }
    end
  end
end
