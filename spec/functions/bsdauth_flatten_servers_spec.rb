require 'spec_helper'

describe 'bsdauth::flatten_servers' do
  it { is_expected.to run.with_params([{'hostname' => '192.0.2.1'}, {'hostname' => '192.0.2.2'}]).and_return(['x-ldap-server=192.0.2.1', 'x-ldap-serveralt0=192.0.2.2']) }
  it { is_expected.to run.with_params([{'hostname' => '192.0.2.1', 'port' => 389}]).and_return(['x-ldap-server=192.0.2.1,389']) }
  it { is_expected.to run.with_params([{'hostname' => '192.0.2.1', 'mode' => 'plain'}]).and_return(['x-ldap-server=192.0.2.1,,plain']) }
  it { is_expected.to run.with_params([{'hostname' => '192.0.2.1', 'version' => 3}]).and_return(['x-ldap-server=192.0.2.1,,,3']) }
end
