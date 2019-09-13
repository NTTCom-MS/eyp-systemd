require 'puppet'

if File.exist?('/bin/systemctl')

  systemd_release=Facter::Util::Resolution.exec('bash -c \'/bin/systemctl --version 2>/dev/null | head -n1 | awk "{ print \\$NF }" \'')

  unless systemd_release.nil? or systemd_release.empty?
    Facter.add('eyp_systemd_release') do
      setcode do
        systemd_release
      end
    end
  end

end
