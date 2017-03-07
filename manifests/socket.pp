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
                        $after       = [],
                        $requires    = [],
                        $wantedby    = [ 'multi-user.target' ],
                      ) {
  include ::systemd

  file { "/etc/systemd/system/${socket_name}.socket":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/socket.erb"),
    notify  => Exec['systemctl reload'],
  }
}
