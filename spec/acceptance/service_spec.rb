require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'systemd class' do
  context 'service' do
    it "cleanup" do
      expect(shell("pkill sleep; echo").exit_code).to be_zero
    end

    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOF

      class { 'systemd': }

      # test

      systemd::service { 'test':
        execstart      => '/bin/sleep 60',
        unset_env_vars => [ 'DEMO_UNSET' ],
        before         => Service['test'],
      }

      service { 'test':
        ensure  => 'running',
        require => Class['::systemd'],
      }

      # test 2

      systemd::service { 'test2':
        execstart => '/bin/sleep 120',
        before    => Service['test2'],
      }

      service { 'test2':
        ensure  => 'running',
        require => Class['::systemd'],
      }

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe file("/etc/systemd/system/test.service") do
      it { should be_file }
      its(:content) { should match 'ExecStart=/bin/sleep 60' }
      its(:content) { should match 'UnsetEnvironment=DEMO_UNSET' }
    end

    it "systemctl status test" do
      expect(shell("systemctl status test").exit_code).to be_zero
    end

    it "systemctl status test2" do
      expect(shell("systemctl status test2").exit_code).to be_zero
    end

    it "check sleep" do
      expect(shell("ps -fea | grep [s]leep").exit_code).to be_zero
    end
  end
end
