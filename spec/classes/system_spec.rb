require 'spec_helper'
describe 'systemd::system' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      context 'with defaults for all parameters' do
        it { should contain_class('systemd::system') }
        it do
          should contain_file('/etc/systemd/system.conf')
            .with_content(/CPUAffinity=1 2/)
            .with_content(/DefaultRestartSec=100ms/)
        end
      end
      context 'with some values set' do
        let(:params) do
          {
            :crash_shell          => 'yes',
            :default_limit_nofile => 333,
            :cpu_affinity         => '1-4'
          }
        end
        it do
          should contain_file('/etc/systemd/system.conf')
            .with_content(/CPUAffinity=1-4/)
            .with_content(/CrashShell=yes/)
            .with_content(/DefaultLimitNOFILE=333/)
        end
      end
    end
  end
end
