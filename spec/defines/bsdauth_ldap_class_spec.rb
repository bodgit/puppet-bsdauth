require 'spec_helper'

describe 'bsdauth::ldap::class' do

  let(:pre_condition) do
    'include ::bsdauth include ::bsdauth::ldap'
  end

  let(:title) do
    'ldap'
  end

  let(:params) do
    {
      'base_dn'          => 'dc=example,dc=com',
      'keep_credentials' => true,
      'referrals'        => false,
      'servers'          => [
        {
          'hostname' => '127.0.0.1',
        },
        {
          'hostname' => '192.0.2.1',
        },
        {
          'hostname' => '192.0.2.2',
          'mode'     => 'ssl',
        },
      ],
    }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}", :compile do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
        })
      end

      it { should contain_bsdauth__class('ldap') }
      it { should contain_bsdauth__ldap__class('ldap') }
      it { should contain_concat__fragment('bsdauth ldap').with_content(<<-'EOS'.gsub(/^ {8}/, ''))
        ldap:\
        	:auth=-ldap:\
        	:x-ldap-basedn=dc=example,dc=com:\
        	:x-ldap-noreferrals:\
        	:x-ldap-refkeepcreds:\
        	:x-ldap-server=127.0.0.1:\
        	:x-ldap-serveralt0=192.0.2.1:\
        	:x-ldap-serveralt1=192.0.2.2,,ssl:\
        	:tc=default:
        EOS
      }
    end
  end
end
