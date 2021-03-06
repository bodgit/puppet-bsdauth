require 'spec_helper'

describe 'bsdauth::yubikey' do

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

      it { should contain_class('bsdauth::yubikey') }
      it { should contain_class('bsdauth::yubikey::config') }
      it { should contain_file('/var/db/yubikey') }
    end
  end
end
