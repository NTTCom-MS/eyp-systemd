class { 'systemd': }

systemd::service { 'test':
  execstart => '/bin/sleep 60',
  before    => Service['test.timer'],
}

systemd::timer { 'test':
  on_boot_sec => '1',
  before      => Service['test.timer'],
}

service { 'test.timer':
  ensure  => 'running',
  require => Class['::systemd'],
}
