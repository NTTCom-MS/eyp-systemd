define systemd::sysvwrapper (
                              $initscript,
                              $ensure               = 'present',
                              $servicename          = $name,
                              $check_time           = '10m',
                              $wait_time_on_startup = '1s',
                              $restart              = 'no',
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
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
    content => template("${module_name}/sysv/status.erb"),
  }

  file { "${initscript}.sysvwrapper.wrapper":
    ensure  => $ensure,
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
    restart   => $restart,
    pid_file  => "/var/run/${servicename}.sysvwrapper.pid",
  }

}
