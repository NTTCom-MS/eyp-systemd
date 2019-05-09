class { 'systemd': }

systemd::socket { 'vago':
  description   => 'vago Server Activation Socket',
  listen_stream => [ '6565' ],
  wantedby      => [ 'sockets.target' ],
}


systemd::service { 'vago':
  description    => 'vago server',
  requires       => [ 'vago.socket' ],
  documentation  => 'man:in.tftpd',
  execstart      => [ "/bin/sleep 30" ],
  standard_input => 'socket',
  also           => [ 'vago.socket' ],
}
