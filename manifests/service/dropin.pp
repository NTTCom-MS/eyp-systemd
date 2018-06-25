define systemd::service::dropin (
  Integer $dropin_order = '99',
  $dropin_name = 'override',
  $servicename = $name,
  Optional $execstart,
  Optional $execstop,
  Optional $execreload,
  Optional $execstartpre,
  Optional $execstartpost,
  Enum[
    'no', 'on-success', 'on-failure', 'on-abnormal', 'on-watchdog', 'on-abort', 'always'
  ] $restart = no,
  String $user = 'root',
  String $group = 'root',
  Boolean $forking = false,
  Optional[String] $pid_file,
  Optional[String] $description,
  Optional[String] $after,
  Optional[Boolean] $remain_after_exit,
  Optional[Enum[
    'simple', 'forking', 'oneshot', 'dbus', 'notify', 'idle'
  ]] $type,
  Optional[Array] $env_vars,
  Optional[Array] $environment_files,
  Optional[Array] $wants,
  Optional[Array] $wantedby = [ 'multi-user.target' ],
  Optional[Array] $requiredby,
  Optional[Array] $after_units,
  Optional[Array] $before_units,
  Optional[Array] $requires,
  Optional[Array] $conflicts,
  Optional[Array] $on_failure,
  Boolean $permissions_start_only = false,
  Optional[String] $timeoutstartsec,
  Optional[String] $timeoutstopsec,
  Optional[String] $timeoutsec,
  Optional[String] $restart_prevent_exit_status,
  Optional[String] $limit_memlock,
  Optional[String] $limit_nofile,
  Optional[String] $limit_nproc,
  Optional[String] $limit_nice,
  Optional[String] $limit_core,
  Optional[String] $runtime_directory,
  Optional[String] $runtime_directory_mode,
  Optional[Integer] $restart_sec,
  Optional[Boolean] $private_tmp,
  Optional[String] $working_directory,
  Optional[String] $root_directory,
  Optional[String] $umask,
  Optional[Integer] $nice,
  Optional[Integer] $oom_score_adjust,
  Optional[Integer] $startlimitinterval,
  Optional[Integer] $startlimitburst,
  Optional[String] $standard_output,
  Optional[String] $standard_error,
  Optional[Enum[
    'kern', 'user', 'mail', 'daemon', 'auth', 'syslog', 'lpr', 'news',
    'uucp', 'cron', 'authpriv', 'ftp', 'local0', 'local1', 'local2',
    'local3', 'local4', 'local5', 'local6', 'local7'
  ]] $syslog_facility,
  Optional[Enum['control-group', 'process', 'mixed', 'none']] $killmode,
  Optional[String] $cpuquota,
  Optional[Array] $successexitstatus,
  Optional[String] $killsignal,
  Optional[Array] $service_alias,
  Optional[Array] $also,
  Optional[String] $default_instance,
) {

  contain ::systemd

  $dropin = true

  file { "/etc/systemd/system/${servicename}.service.d/${dropin_order}-${dropin_name}.conf":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/service.erb"),
    notify  => Exec['systemctl daemon-reload'],
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
