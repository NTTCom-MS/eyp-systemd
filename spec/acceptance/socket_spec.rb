require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'systemd class' do
  context 'basic setup' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOF

      class { 'systemd': }

      systemd::socket { 'test':
        listen_stream => '7878',
        after         => 'network.target',
        requires      => [ 'network.target' ],
        wantedby      => [ 'sockets.target' ],
      }

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe file("/etc/systemd/system/test.socket") do
      it { should be_file }
      its(:content) { should match 'ListenStream=7878' }
    end

    describe file("/etc/systemd/logind.conf") do
      it { should be_file }
      its(:content) { should match 'RemoveIPC=no' }
    end

    it "systemctl status" do
      expect(shell("systemctl status test").exit_code).to be_zero
    end

    it "check sleep" do
      expect(shell("ps -fea | grep sleep").exit_code).to be_zero
    end
  end
end
