require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'systemd class' do

  context 'basic setup' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOF

      class { 'systemd': }

      systemd::service { 'test':
        execstart => 'sleep 60',
        before    => Service['test'],
      }

      service { 'test':
        ensure => 'running',
      }

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe file("/etc/systemd/system/test.service") do
      it { should be_file }
      its(:content) { should match 'ExecStart=sleep 60' }
    end

    it "sleep 60 running" do
      expect(shell("ps -fea | grep sleep 60").exit_code).to be_zero
    end

    it "systemctl status" do
      expect(shell("systemctl status test").exit_code).to be_zero
    end

    it "sleep 60 deixem pasar" do
      expect(shell("sleep 60").exit_code).to be_zero
    end

    it "systemctl status no hi hauria de ser" do
      expect(shell("systemctl status test").exit_code).to_not be_zero
    end

  end
end
