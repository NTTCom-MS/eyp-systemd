define systemd::sysvwrapper (
                              $initscript,
                              $servicename=$name,
                            ) {

  if ! defined(Class['systemd'])
  {
    fail('You must include the systemd base class before using any systemd defined resources')
  }

  file { "/etc/init.d/${servicename}.sysvwrapper.status":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
    content => template("${module_name}/sysv/status.erb"),
  }

  file { "/etc/init.d/${servicename}.sysvwrapper.wrapper":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
    content => template("${module_name}/sysv/wrapper.erb"),
  }

  systemd::service { $servicename:
    execstart => "/bin/bash ${initscript} start",
    execstop  => "/bin/bash ${initscript} stop",
    require   => File[ [
                      "/etc/init.d/${servicename}.sysvwrapper.wrapper",
                      "/etc/init.d/${servicename}.sysvwrapper.status",
                      ] ],
    before    => Service[$servicename],
    notify    => Service[$servicename],
    forking   => true,
    restart   => 'no',
    pid_file  => "/var/run/${servicename}.sysvwrapper.pid",
  }

}
