define systemd::service::dropin (
                                  $ensure                      = 'present',
                                  $dropin_order                = '99',
                                  $dropin_name                 = 'override',
                                  $purge_dropin_dir            = true,
                                  $servicename                 = $name,
                                  $execstart                   = undef,
                                  $execstop                    = undef,
                                  $execstoppre                 = undef,
                                  $execstoppost                = undef,
                                  $execreload                  = undef,
                                  $execstartpre                = undef,
                                  $execstartpost               = undef,
                                  $restart                     = undef,
                                  $user                        = undef,
                                  $group                       = undef,
                                  $forking                     = false,
                                  $pid_file                    = undef,
                                  $remain_after_exit           = undef,
                                  $type                        = undef,
                                  $env_vars                    = [],
                                  $environment_files           = [],
                                  $permissions_start_only      = undef,
                                  $timeoutstartsec             = undef,
                                  $timeoutstopsec              = undef,
                                  $timeoutsec                  = undef,
                                  $restart_prevent_exit_status = undef,
                                  $limit_memlock               = undef,
                                  $limit_nofile                = undef,
                                  $limit_nproc                 = undef,
                                  $limit_nice                  = undef,
                                  $limit_core                  = undef,
                                  $runtime_directory           = undef,
                                  $runtime_directory_mode      = undef,
                                  $restart_sec                 = undef,
                                  $private_tmp                 = false,
                                  $working_directory           = undef,
                                  $root_directory              = undef,
                                  $umask                       = undef,
                                  $nice                        = undef,
                                  $oom_score_adjust            = undef,
                                  $startlimitinterval          = undef,
                                  $startlimitburst             = undef,
                                  $standard_input              = undef,
                                  $standard_output             = undef,
                                  $standard_error              = undef,
                                  $syslog_facility             = undef,
                                  $syslog_identifier           = undef,
                                  $killmode                    = undef,
                                  $cpuquota                    = undef,
                                  $tasksmax                    = undef,
                                  $successexitstatus           = [],
                                  $killsignal                  = undef,
                                  # install
                                  $also                        = [],
                                  $default_instance            = undef,
                                  $service_alias               = [],
                                  $wantedby                    = [ 'multi-user.target' ],
                                  $requiredby                  = [],
                                  # unit
                                  $description                 = undef,
                                  $documentation               = undef,
                                  $wants                       = [],
                                  $after                       = undef,
                                  $after_units                 = [],
                                  $before_units                = [],
                                  $requires                    = [],
                                  $binds_to                    = [],
                                  $conflicts                   = [],
                                  $on_failure                  = [],
                                  $partof                      = undef,
                                  $allow_isolate               = undef,
                                ) {

  # if($restart!=undef)
  # {
  #   # Takes one of no, on-success, on-failure, on-abnormal, on-watchdog, on-abort, or always.
  #   validate_re($restart, [ '^no$', '^on-success$', '^on-failure$', '^on-abnormal$', '^on-watchdog$', '^on-abort$', '^always$'], "Not a supported restart type: ${restart} - Takes one of no, on-success, on-failure, on-abnormal, on-watchdog, on-abort, or always")
  # }

  if versioncmp($::puppetversion, '4.0.0') >= 0
  {
    contain ::systemd
  }
  else
  {
    include ::systemd
  }

  $dropin = true

  concat { "/etc/systemd/system/${servicename}.service.d/${dropin_order}-${dropin_name}.conf":
    ensure => $ensure,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Exec['systemctl daemon-reload'],
  }

  concat::fragment { "service dropin ${servicename} ${dropin_name} unit":
    target  => "/etc/systemd/system/${servicename}.service.d/${dropin_order}-${dropin_name}.conf",
    order   => '00',
    content => template("${module_name}/section/unit.erb"),
  }

  concat::fragment { "service dropin ${servicename} ${dropin_name} install":
    target  => "/etc/systemd/system/${servicename}.service.d/${dropin_order}-${dropin_name}.conf",
    order   => '01',
    content => template("${module_name}/section/install.erb"),
  }

  concat::fragment { "service dropin ${servicename} ${dropin_name} service":
    target  => "/etc/systemd/system/${servicename}.service.d/${dropin_order}-${dropin_name}.conf",
    order   => '02',
    content => template("${module_name}/section/service.erb"),
  }

  if(!defined(File["/etc/systemd/system/${servicename}.service.d/"]))
  {
    file { "/etc/systemd/system/${servicename}.service.d/":
      ensure  => 'directory',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      purge   => $purge_dropin_dir,
      recurse => $purge_dropin_dir,
      notify  => Exec['systemctl daemon-reload'],
    }
  }
}
