require 'spec_helper'

describe 'bsdauth::skey' do

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

      it { should contain_class('bsdauth::skey') }
      it { should contain_class('bsdauth::skey::config') }
      it { should contain_file('/etc/skey') }
    end
  end
end
