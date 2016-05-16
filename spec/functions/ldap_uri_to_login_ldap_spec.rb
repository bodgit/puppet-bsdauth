require 'spec_helper'

describe 'ldap_uri_to_login_ldap' do
  it { expect { should run.with_params('http://192.0.2.1', true) }.to raise_error(/Requires either ldap:\/\/\/ or ldaps:\/\/\/ URI to work with/) }
  it { expect { should run.with_params('192.0.2.1', false) }.to raise_error(/Requires either ldap:\/\/\/ or ldaps:\/\/\/ URI to work with/) }
  it { should run.with_params('ldap://192.0.2.1', true).and_return(['x-ldap-server=192.0.2.1,,starttls']) }
  it { should run.with_params('ldaps://192.0.2.1', true).and_return(['x-ldap-server=192.0.2.1,,ssl']) }
  it { should run.with_params(['ldap://192.0.2.1:389'], false).and_return(['x-ldap-server=192.0.2.1,,plain']) }
  it { should run.with_params(['ldaps://192.0.2.1:636'], false).and_return(['x-ldap-server=192.0.2.1,,ssl']) }
  it { should run.with_params(['ldap://192.0.2.1:400', 'ldaps://192.0.2.2:700'], false).and_return(['x-ldap-server=192.0.2.1,400,plain', 'x-ldap-serveralt0=192.0.2.2,700,ssl']) }
end
