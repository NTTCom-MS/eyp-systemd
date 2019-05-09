class { 'systemd': }

systemd::service { 'test':
  execstart => '/bin/sleep 60',
  before    => Service['test'],
}

systemd::timer { 'test':
  on_boot_sec => '1',
  before    => Service['test'],
}

service { 'test.timer':
  ensure  => 'running',
  require => Class['::systemd'],
}
