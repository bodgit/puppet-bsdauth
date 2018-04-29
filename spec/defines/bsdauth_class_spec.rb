require 'spec_helper'

describe 'bsdauth::class' do

  let(:pre_condition) do
    'include ::bsdauth'
  end

  let(:title) do
    'foo'
  end

  let(:params) do
    {
      'capabilities' => ['tc=default'],
    }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}", :compile do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
        })
      end

      it { should contain_bsdauth__class('foo') }
      it { should contain_concat__fragment('bsdauth foo').with_content(<<-'EOS'.gsub(/^ {8}/, ''))
        foo:\
        	:tc=default:
        EOS
      }
    end
  end
end
