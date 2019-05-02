# [Socket]
# ListenStream=80
# ListenStream=0.0.0.0:80
# After=network.target
# Requires=network.target
#
# [Install]
# WantedBy=sockets.target
define systemd::socket(
                        $listen_stream,
                        $socket_name = $name,
                        $after_units = [],
                        $requires    = [],
                        #unit
                        $description = undef,
                        #install
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

  concat { "/etc/systemd/system/${socket_name}.socket":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Exec['systemctl daemon-reload'],
  }

  concat::fragment { "${socket_name} unit":
    target  => "/etc/systemd/system/${socket_name}.timer",
    order   => '00',
    content => template("${module_name}/section/unit.erb"),
  }

  concat::fragment { "${socket_name} install":
    target  => "/etc/systemd/system/${socket_name}.timer",
    order   => '01',
    content => template("${module_name}/section/install.erb"),
  }

  concat::fragment { "${socket_name} socket":
    target  => "/etc/systemd/system/${socket_name}.timer",
    order   => '02',
    content => template("${module_name}/section/socket.erb"),
  }
}
