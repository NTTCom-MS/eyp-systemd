class { 'systemd': }

systemd::target { 'demotarget':
  description => 'demo target acceptance',
}
