class { 'systemd': }

systemd::service { 'test':
  execstart => '/bin/sleep 60',
  before    => Service['test'],
}

service { 'test':
  ensure  => 'running',
  require => Class['::systemd'],
}
