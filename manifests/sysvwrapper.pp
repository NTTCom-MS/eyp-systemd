define systemd::sysvwrapper (
  $initscript,
  String $servicename = $name,
  String $check_time = '10m',
  String $wait_time_on_startup = '1s',
) {

  contain ::systemd

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
    require   => File[
      "${initscript}.sysvwrapper.wrapper",
      "${initscript}.sysvwrapper.status",
    ],
    forking   => true,
    restart   => 'no',
    pid_file  => "/var/run/${servicename}.sysvwrapper.pid",
  }
}
