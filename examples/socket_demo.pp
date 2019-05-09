class { 'systemd': }

systemd::socket { 'vago':
  description   => 'vago Server Activation Socket',
  listen_stream => [ '6565' ],
  wantedby      => [ 'sockets.target' ],
  accept        => true,
}


systemd::service { 'vago@':
  description    => 'vago server',
  requires       => [ 'vago.socket' ],
  execstart      => [ "/bin/sleep 30" ],
  standard_input => 'socket',
  also           => [ 'vago.socket' ],
  before         => Service['vago'],
}

service { 'vago':
  ensure  => 'running',
  require => Class['::systemd'],
}
