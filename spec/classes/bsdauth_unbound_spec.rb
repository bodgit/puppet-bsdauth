require 'spec_helper'

describe 'bsdauth::unbound' do

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

      it { should contain_bsdauth__class('unbound') }
      it { should contain_class('bsdauth::unbound') }
      it { should contain_concat__fragment('bsdauth unbound').with_content(<<-'EOS'.gsub(/^ {8}/, ''))
        unbound:\
        	:openfiles=512:\
        	:tc=daemon:
        EOS
      }
    end
  end
end
