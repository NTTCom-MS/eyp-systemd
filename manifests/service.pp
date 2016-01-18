define systemd::service (
                          $execstart,
                          $restart='always',
                          $user='root',
                          $group='root',
                          $servicename=$name,
                          $forking=false,
                        ) {
  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  file { "/etc/systemd/system/${servicename}.service":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/service.erb"),
    notify  => Exec["systemctl reload ${servicename}"],
  }

  exec { "systemctl reload ${servicename}":
    command     => 'systemctl daemon-reload',
    refreshonly => true,
  }

}
