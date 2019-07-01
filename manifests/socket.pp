# [Socket]
# ListenStream=80
# ListenStream=0.0.0.0:80
# After=network.target
# Requires=network.target
#
# [Install]
# WantedBy=sockets.target
define systemd::socket(
                        $ensure      = 'present',
                        $listen_stream,
                        $socket_name = $name,
                        $after_units = [],
                        $requires    = [],
                        $description = undef,
                        $wantedby    = [ 'multi-user.target' ],
                      ) {
  if versioncmp($::puppetversion, '4.0.0') >= 0
  {
    contain ::systemd
  }
  else
  {
    include ::systemd
  }

  file { "/etc/systemd/system/${socket_name}.socket":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/socket.erb"),
    notify  => Exec['systemctl daemon-reload'],
  }
}
