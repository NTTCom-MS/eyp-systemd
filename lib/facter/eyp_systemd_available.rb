require 'puppet'

systemd_available = 'false'
if File.exist?('/bin/systemctl')
  systemd_available = 'true'
end

Facter.add('eyp_systemd_available') do
  setcode do
    systemd_available
  end
end
