require 'spec_helper'

describe 'bsdauth::ldap' do

  let(:params) do
    {
      'base_dn' => 'dc=example,dc=com',
      'servers' => [
        '127.0.0.1',
        '192.0.2.1',
        '192.0.2.2',
      ],
    }
  end

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

      it { should contain_anchor('bsdauth::ldap::begin') }
      it { should contain_anchor('bsdauth::ldap::end') }
      it { should contain_bsdauth__class('ldap') }
      it { should contain_class('bsdauth::ldap') }
      it { should contain_class('bsdauth::ldap::config') }
      it { should contain_class('bsdauth::ldap::install') }
      it { should contain_concat__fragment('ldap').with_content(<<-EOS.gsub(/^ +/, ''))
        ldap:\\
        	:auth=-ldap:\\
        	:x-ldap-basedn=dc=example,dc=com:\\
        	:x-ldap-filter=(&(objectclass=posixAccount)(uid=%u)):\\
        	:x-ldap-server=127.0.0.1:\\
        	:x-ldap-serveralt0=192.0.2.1:\\
        	:x-ldap-serveralt1=192.0.2.2:\\
        	:tc=default:
        EOS
      }
      it { should contain_package('login_ldap') }
    end
  end
end
