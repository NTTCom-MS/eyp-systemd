require 'spec_helper'

describe 'systemd::service::dropin' do
  let(:pre_condition) do
    "include '::systemd'"
  end
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let (:facts) {facts}
      let(:title) { 'foobar' }
      context 'with minimum parameters' do
        it { should compile.with_all_deps }
        it { should contain_file('/etc/systemd/system/foobar.service.d/99-override.conf') }
      end
      context 'with execstart parameter' do
        let(:params) do
          {
            execstart: '/usr/bin/foobar'
          }
        end
        it { should compile.with_all_deps }
        it do
          should contain_file('/etc/systemd/system/foobar.service.d/99-override.conf')
            .with_content(/^ExecStart=$/)
            .with_content(/^ExecStart=\/usr\/bin\/foobar$/)
        end
      end
    end
  end
end
