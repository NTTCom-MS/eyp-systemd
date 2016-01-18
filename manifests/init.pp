#
class systemd inherits systemd::params {

  exec { 'systemctl reload':
    command     => 'systemctl daemon-reload',
    refreshonly => true,
  }
}
