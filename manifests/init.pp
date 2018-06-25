class systemd (
  Boolean $manage_journald = false,
  Boolean $manage_logind = false,
  Boolean $manage_resolved = false,
  Boolean $manage_system = false,
  Boolean $manage_timesyncd = false,
) {

  if($facts['service_provider'] != 'systemd') {
    fail('OS not using SystemD')
  } else {

    exec { 'systemctl daemon-reload':
      command     => 'systemctl daemon-reload',
      path        => '/bin:/sbin:/usr/bin:/usr/sbin',
      refreshonly => true,
    }

    if($manage_journald) {
      include ::systemd::journald
    }

    if($manage_logind) {
      include ::systemd::logind
    }

    if($manage_resolved) {
      include ::systemd::resolved
    }

    if($manage_system) {
      include ::systemd::system
    }

    if($manage_timesyncd) {
      include ::systemd::timesyncd
    }
  }
}
