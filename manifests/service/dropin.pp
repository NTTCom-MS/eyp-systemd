define systemd::service::dropin (
  Integer $dropin_order = '99',
  String $dropin_name = 'override',
  Boolean $purge_dropin_dir = true,
  $servicename = $name,
  Enum[
    'no', 'on-success', 'on-failure', 'on-abnormal', 'on-watchdog', 'on-abort', 'always'
  ] $restart = no,
  String $user = 'root',
  String $group = 'root',
  Boolean $forking = false,
  Boolean $permissions_start_only = false,
  Optional[Variant[Array, String]] $execstart = undef,
  Optional[Variant[Array, String]] $execstop = undef,
  Optional[Variant[Array, String]] $execreload = undef,
  Optional[Variant[Array, String]] $execstartpre = undef,
  Optional[Variant[Array, String]] $execstartpost = undef,
  Optional[String] $pid_file = undef,
  Optional[String] $description = undef,
  Optional[String] $after = undef,
  Optional[Boolean] $remain_after_exit = undef,
  Optional[Enum[
    'simple', 'forking', 'oneshot', 'dbus', 'notify', 'idle'
  ]] $type = undef,
  Optional[Array] $env_vars = [],
  Optional[Array] $environment_files = [],
  Optional[Array] $wants = [],
  Optional[Array] $wantedby = [ 'multi-user.target' ],
  Optional[Array] $requiredby = [],
  Optional[Array] $after_units = [],
  Optional[Array] $before_units = [],
  Optional[Array] $requires = [],
  Optional[Array] $conflicts = [],
  Optional[Array] $on_failure = [],
  Optional[String] $timeoutstartsec = undef,
  Optional[String] $timeoutstopsec = undef,
  Optional[String] $timeoutsec = undef,
  Optional[String] $restart_prevent_exit_status = undef,
  Optional[String] $limit_memlock = undef,
  Optional[String] $limit_nofile = undef,
  Optional[String] $limit_nproc = undef,
  Optional[String] $limit_nice = undef,
  Optional[String] $limit_core = undef,
  Optional[String] $runtime_directory = undef,
  Optional[String] $runtime_directory_mode = undef,
  Optional[Integer] $restart_sec = undef,
  Optional[Boolean] $private_tmp = undef,
  Optional[String] $working_directory = undef,
  Optional[String] $root_directory = undef,
  Optional[String] $umask = undef,
  Optional[Integer] $nice = undef,
  Optional[Integer] $oom_score_adjust = undef,
  Optional[Integer] $startlimitinterval = undef,
  Optional[Integer] $startlimitburst = undef,
  Optional[String] $standard_output = undef,
  Optional[String] $standard_error = undef,
  Optional[Enum[
    'kern', 'user', 'mail', 'daemon', 'auth', 'syslog', 'lpr', 'news',
    'uucp', 'cron', 'authpriv', 'ftp', 'local0', 'local1', 'local2',
    'local3', 'local4', 'local5', 'local6', 'local7'
  ]] $syslog_facility = undef,
  Optional[Enum['control-group', 'process', 'mixed', 'none']] $killmode = undef,
  Optional[String] $cpuquota = undef,
  Optional[Array] $successexitstatus = [],
  Optional[String] $killsignal = undef,
  Optional[Array] $service_alias = [],
  Optional[Array] $also = [],
  Optional[String] $default_instance = undef,
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
