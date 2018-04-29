require 'spec_helper'

describe 'bsdauth::pbuild' do

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

      it { should contain_bsdauth__class('pbuild') }
      it { should contain_class('bsdauth::pbuild') }
      it { should contain_concat__fragment('bsdauth pbuild').with_content(<<-'EOS'.gsub(/^ {8}/, ''))
        pbuild:\
        	:datasize-max=infinity:\
        	:datasize-cur=4096M:\
        	:maxproc-max=1024:\
        	:maxproc-cur=256:\
        	:tc=default:
        EOS
      }
    end
  end
end
