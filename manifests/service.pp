define systemd::service (
                          $execstart,
                          $execstop                    = undef,
                          $execreload                  = undef,
                          $execstartpre                = undef,
                          $restart                     = 'always',
                          $user                        = 'root',
                          $group                       = 'root',
                          $servicename                 = $name,
                          $forking                     = false,
                          $pid_file                    = undef,
                          $description                 = undef,
                          $after                       = undef,
                          $remain_after_exit           = undef,
                          $type                        = undef,
                          $env_vars                    = [],
                          $environment_files           = [],
                          $wants                       = [],
                          $wantedby                    = [ 'multi-user.target' ],
                          $requiredby                  = [],
                          $after_units                 = [],
                          $before_units                = [],
                          $requires                    = [],
                          $conflicts                   = [],
                          $permissions_start_only      = false,
                          $timeoutstartsec             = undef,
                          $timeoutstopsec              = undef,
                          $timeoutsec                  = undef,
                          $restart_prevent_exit_status = undef,
                          $limit_nofile                = undef,
                          $limit_nproc                 = undef,
                          $limit_nice                  = undef,
                          $runtime_directory           = undef,
                          $runtime_directory_mode      = undef,
                          $restart_sec                 = undef,
                          $private_tmp                 = false,
                          $working_directory           = undef,
                          $root_directory              = undef,
                          $umask                       = '0022',
                          $nice                        = undef,
                          $oom_score_adjust            = undef,
                        ) {
  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  if ($env_vars != undef )
  {
    validate_array($env_vars)
  }

  if($type!=undef and $forking==true)
  {
    fail('Incompatible options: type / forking')
  }

  # Takes one of no, on-success, on-failure, on-abnormal, on-watchdog, on-abort, or always.
  validate_re($restart, [ '^no$', '^on-success$', '^on-failure$', '^on-abnormal$', '^on-watchdog$', '^on-abort$', '^always$'], "Not a supported restart type: ${restart} - Takes one of no, on-success, on-failure, on-abnormal, on-watchdog, on-abort, or always")

  validate_array($wants)
  validate_array($wantedby)
  validate_array($requiredby)
  validate_array($after_units)
  validate_array($before_units)
  validate_array($requires)
  validate_array($conflicts)

  include ::systemd

  file { "/etc/systemd/system/${servicename}.service":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/service.erb"),
    notify  => Exec['systemctl reload'],
  }

}
