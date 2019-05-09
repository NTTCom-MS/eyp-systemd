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
  execstart      => [ "/bin/sleep 30" ],
  standard_input => 'socket',
  also           => [ 'vago.socket' ],
  before         => Service['vago.socket'],
}

service { 'vago.socket':
  ensure => 'running',
}
