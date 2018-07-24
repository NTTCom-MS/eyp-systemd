define systemd::sysvwrapper (
                              $initscript,
                              $servicename          = $name,
                              $check_time           = '10m',
                              $wait_time_on_startup = '1s',
                            ) {

  if versioncmp($::puppetversion, '4.0.0') >= 0
  {
    contain ::systemd
  }
  else
  {
    include ::systemd
  }

  file { "${initscript}.sysvwrapper.status":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
    content => template("${module_name}/sysv/status.erb"),
  }

  file { "${initscript}.sysvwrapper.wrapper":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
    content => template("${module_name}/sysv/wrapper.erb"),
  }

  systemd::service { $servicename:
    execstart => "/bin/bash ${initscript}.sysvwrapper.wrapper start",
    execstop  => "/bin/bash ${initscript}.sysvwrapper.wrapper stop",
    require   => File[ [
                      "${initscript}.sysvwrapper.wrapper",
                      "${initscript}.sysvwrapper.status",
                      ] ],
    forking   => true,
    restart   => 'no',
    pid_file  => "/var/run/${servicename}.sysvwrapper.pid",
  }

}
