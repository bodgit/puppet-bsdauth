require 'spec_helper'

describe 'BSDAuth::LDAP::Server' do
  it { is_expected.to allow_value({'hostname' => '192.0.2.1'}) }
  it { is_expected.to allow_value({'hostname' => '192.0.2.1', 'port' => 389}) }
  it { is_expected.to allow_value({'hostname' => '192.0.2.1', 'mode' => 'plain'}) }
  it { is_expected.to allow_value({'hostname' => '192.0.2.1', 'mode' => 'ssl'}) }
  it { is_expected.to allow_value({'hostname' => '192.0.2.1', 'mode' => 'starttls'}) }
  it { is_expected.to allow_value({'hostname' => '192.0.2.1', 'version' => 3}) }
  it { is_expected.not_to allow_value({}) }
  it { is_expected.not_to allow_value({'invalid' => 'invalid'}) }
  it { is_expected.not_to allow_value({'hostname' => '192.0.2.1', 'mode' => 'invalid'}) }
  it { is_expected.not_to allow_value({'hostname' => '192.0.2.1', 'version' => 4}) }
end
