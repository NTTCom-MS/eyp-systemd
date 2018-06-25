define systemd::socket(
  $listen_stream,
  $socket_name = $name,
  Array $after_units = [],
  Array $requires = [],
  String $description = '',
  Array $wantedby = [ 'multi-user.target' ],
) {
  contain ::systemd

  file { "/etc/systemd/system/${socket_name}.socket":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/socket.erb"),
    notify  => Exec['systemctl daemon-reload'],
  }
}
