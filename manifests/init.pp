#
class systemd inherits systemd::params {

  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  exec { 'systemctl reload':
    command     => 'systemctl daemon-reload',
    refreshonly => true,
  }
}
