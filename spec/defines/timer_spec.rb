require 'spec_helper'

describe 'systemd::timer' do
  let(:pre_condition) do
    "include '::systemd'"
  end
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let (:facts) {facts}
      let(:title) { 'foobar' }
      context 'with minimum parameters' do
        it { should compile.with_all_deps }
        it do
          should contain_file('/etc/systemd/system/foobar.timer')
            .without_content(/^OnCalendar=/)
        end
      end
      context 'with calendar parameters' do
        let(:params) do
          {
            on_calendar: '06:00:00'
          }
        end
        it { should compile.with_all_deps }
        it do
          should contain_file('/etc/systemd/system/foobar.timer')
            .with_content(/^OnCalendar=06:00:00$/)
        end
      end
      context 'with on_boot_sec parameters' do
        let(:params) do
          {
            on_boot_sec: '1h'
          }
        end
        it { should compile.with_all_deps }
        it do
          should contain_file('/etc/systemd/system/foobar.timer')
            .with_content(/^OnBootSec=1h$/)
        end
      end
    end
  end
end
