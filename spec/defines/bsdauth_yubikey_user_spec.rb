require 'spec_helper'

describe 'bsdauth::yubikey::user' do

  let(:pre_condition) do
    'include ::bsdauth include ::bsdauth::yubikey'
  end

  let(:title) do
    'test'
  end

  let(:params) do
    {
      'key' => 'deadbeefcafebabec0ffee0123456789',
      'uid' => 'cafedeadbeef',
    }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}", :compile do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
        })
      end

      it { should contain_bsdauth__yubikey__user('test') }
      it { should contain_file('/var/db/yubikey/test.ctr').with_content("0\n") }
      it { should contain_file('/var/db/yubikey/test.key').with_content("deadbeefcafebabec0ffee0123456789\n") }
      it { should contain_file('/var/db/yubikey/test.uid').with_content("cafedeadbeef\n") }
    end
  end
end
