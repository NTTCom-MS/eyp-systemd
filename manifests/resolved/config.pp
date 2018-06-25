class systemd::resolved::config inherits systemd::resolved {
  file { '/etc/systemd/resolved.conf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/resolved.erb"),
  }
}
