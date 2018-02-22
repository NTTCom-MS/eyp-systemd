#
# https://wiki.archlinux.org/index.php/systemd#Service_types
#
class systemd($removeipc = 'no') inherits systemd::params {

  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  exec { 'systemctl daemon-reload':
    command     => 'systemctl daemon-reload',
    refreshonly => true,
  }

  #TODO: compatibility, to be removed in 0.2
  # related: https://github.com/NTTCom-MS/eyp-systemd/issues/35
  exec { 'systemctl reload':
    command     => 'systemctl daemon-reload',
    refreshonly => true,
  }

  include ::systemd::logind
}
