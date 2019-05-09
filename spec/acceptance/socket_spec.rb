require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'systemd class' do
  context 'socket' do
    it "cleanup" do
      expect(shell("pkill sleep; echo").exit_code).to be_zero
    end

    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOF

      class { 'systemd': }

      systemd::socket { 'vago':
        description   => 'vago Server Activation Socket',
        listen_stream => [ '6565' ],
        wantedby      => [ 'sockets.target' ],
        accept        => true,
        before        => Service['vago.socket'],
      }


      systemd::service { 'vago@':
        description    => 'vago server',
        requires       => [ 'vago.socket' ],
        execstart      => [ '/bin/sleep 30' ],
        standard_input => 'socket',
        also           => [ 'vago.socket' ],
        before         => Service['vago.socket'],
      }

      service { 'vago.socket':
        ensure => 'running',
      }


      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe file("/etc/systemd/system/vago.socket") do
      it { should be_file }
      its(:content) { should match 'ListenStream=6565' }
    end

    it "systemctl status" do
      expect(shell("systemctl status vago.socket").exit_code).to be_zero
    end

    it "check absensce sleep" do
      expect(shell("if [ $(ps -fea | grep -c [s]leep) -eq 0 ]; then /bin/true; else /bin/false; fi; echo $?").exit_code).to be_zero
    end

    it "activate service" do
      expect(shell("echo | telnet 127.0.0.1 6565 | grep \"Escape character\"").exit_code).to be_zero
    end

    it "check sleep" do
      expect(shell("ps -fea | grep [s]leep").exit_code).to be_zero
    end

    describe port(6565) do
      it { should be_listening }
    end

  end
end
