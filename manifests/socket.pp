# [Socket]
# ListenStream=80
# ListenStream=0.0.0.0:80
# After=network.target
# Requires=network.target
#
# [Install]
# WantedBy=sockets.target
define systemd::socket(
                        $listen_stream    = undef,
                        $listen_datagram  = undef,
                        $socket_name      = $name,
                        # install
                        $also             = [],
                        $default_instance = undef,
                        $service_alias    = [],
                        $wantedby         = [ 'multi-user.target' ],
                        $requiredby       = [],
                        # unit
                        $description      = undef,
                        $documentation    = undef,
                        $wants            = [],
                        $after            = undef,
                        $after_units      = [],
                        $before_units     = [],
                        $requires         = [],
                        $conflicts        = [],
                        $on_failure       = [],
                        $partof           = undef,
                        $allow_isolate    = undef,
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
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Exec['systemctl daemon-reload'],
  }

  concat::fragment { "${socket_name} unit":
    target  => "/etc/systemd/system/${socket_name}.socket",
    order   => '00',
    content => template("${module_name}/section/unit.erb"),
  }

  concat::fragment { "${socket_name} install":
    target  => "/etc/systemd/system/${socket_name}.socket",
    order   => '01',
    content => template("${module_name}/section/install.erb"),
  }

  concat::fragment { "${socket_name} socket":
    target  => "/etc/systemd/system/${socket_name}.socket",
    order   => '02',
    content => template("${module_name}/section/socket.erb"),
  }
}
