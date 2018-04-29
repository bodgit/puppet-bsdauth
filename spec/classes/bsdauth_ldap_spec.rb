require 'spec_helper'

describe 'bsdauth::ldap' do

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

      it { should contain_class('bsdauth::ldap') }
      it { should contain_class('bsdauth::ldap::config') }
      it { should contain_class('bsdauth::ldap::install') }
      it { should contain_package('login_ldap') }
    end
  end
end
