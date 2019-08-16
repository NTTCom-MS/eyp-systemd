# puppet2sitepp @systemdservices
define systemd::service (
                          $ensure                      = 'present',
                          $servicename                 = $name,
                          $execstart                   = undef,
                          $execstop                    = undef,
                          $execreload                  = undef,
                          $execstartpre                = undef,
                          $execstartpost               = undef,
                          $restart                     = undef,
                          $user                        = 'root',
                          $group                       = 'root',
                          $forking                     = false,
                          $pid_file                    = undef,
                          $remain_after_exit           = undef,
                          $type                        = undef,
                          $env_vars                    = [],
                          $environment_files           = [],
                          $permissions_start_only      = false,
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

  if($type != undef and $forking == true)
  {
    fail('Incompatible options: type / forking')
  }

  if($type != 'oneshot' and $execstart.is_a(Array) and count($execstart) > 1)
  {
    fail('Incompatible options: There are multiple execstart values and Type is not "oneshot"')
  }

  if($type != 'oneshot' and $execstop.is_a(Array) and count($execstop) > 1)
  {
    fail('Incompatible options: There are multiple execstop values and Type is not "oneshot"')
  }

  include ::systemd

  concat { "/etc/systemd/system/${servicename}.service":
    ensure => $ensure,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Exec['systemctl daemon-reload'],
  }

  concat::fragment { "service ${servicename} unit":
    target  => "/etc/systemd/system/${servicename}.service",
    order   => '00',
    content => template("${module_name}/section/unit.erb"),
  }

  concat::fragment { "service ${servicename} install":
    target  => "/etc/systemd/system/${servicename}.service",
    order   => '01',
    content => template("${module_name}/section/install.erb"),
  }

  concat::fragment { "service ${servicename} service":
    target  => "/etc/systemd/system/${servicename}.service",
    order   => '02',
    content => template("${module_name}/section/service.erb"),
  }
}
