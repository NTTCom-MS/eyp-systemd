require 'spec_helper'
describe 'systemd' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      context 'with defaults for all parameters' do
        it { should contain_class('systemd') }
      end
    end
  end
end
