require 'spec_helper'
describe 'systemd::logind' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      context 'with defaults for all parameters' do
        it { should contain_class('systemd::logind') }
        it do
          should contain_file('/etc/systemd/logind.conf')
            .with_content(/KillExcludeUsers=root/)
            .with_content(/KillUserProcesses=yes/)
            .with_content(/NAutoVTs=6/)
            .without_content(/KillOnlyUsers/)
            .with_content(/InhibitDelayMaxSec=5/)
        end
      end
      context 'with some values set' do
        let(:params) do
          {
            :inhibit_delay_max_sec => 55,
            :kill_only_users       => ['foo', 'bar']
          }
        end
        it do
          should contain_file('/etc/systemd/logind.conf')
            .with_content(/KillExcludeUsers=root/)
            .with_content(/KillUserProcesses=yes/)
            .with_content(/NAutoVTs=6/)
            .with_content(/KillOnlyUsers=foo bar/)
            .with_content(/InhibitDelayMaxSec=55/)
        end
      end
    end
  end
end
