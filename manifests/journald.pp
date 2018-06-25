class systemd::journald (
  Boolean $manage_service = true,
  Boolean $manage_docker_service = true,
  Enum['running', 'stopped' ]$service_ensure = 'running',
  Boolean $service_enable = true,
  Boolean $compress = true,
  Boolean $forward_to_console = false,
  Boolean $forward_to_kmsg = false,
  Boolean $forward_to_syslog = true,
  Boolean $forward_to_wall = true,
  $max_file_sec = '1month',
  Enum[
    'emerg', 'alert', 'crit', 'err', 'warning', 'notice', 'info', 'debug'
  ] $max_level_console = 'info',
  Enum[
    'emerg', 'alert', 'crit', 'err', 'warning', 'notice', 'info', 'debug'
  ] $max_level_kmsg = 'notice',
  Enum[
    'emerg', 'alert', 'crit', 'err', 'warning', 'notice', 'info', 'debug'
  ] $max_level_store = 'debug',
  Enum[
    'emerg', 'alert', 'crit', 'err', 'warning', 'notice', 'info', 'debug'
  ] $max_level_syslog = 'debug',
  Enum[
    'emerg', 'alert', 'crit', 'err', 'warning', 'notice', 'info', 'debug'
  ] $max_level_wall = 'emerg',
  Optional[String] $max_retention_sec = undef,
  Integer $rate_limit_burst = 1000,
  $rate_limit_interval = '30s',
  Optional[String] $runtime_keep_free = undef,
  Optional[String] $runtime_max_files_size = undef,
  Optional[String] $runtime_max_use = undef,
  Boolean $seal = true,
  $split_mode = 'uid',
  $storage  = 'auto',
  $sync_interval_sec = '5m',
  Optional[String] $system_keep_free = undef,
  Optional[String] $system_max_file_size = undef,
  Optional[String] $system_max_use = undef,
  $tty_path = '/dev/console'
) {

  contain '::systemd::journald::config'
  contain '::systemd::journald::service'

  Class['::systemd::journald::config']
  ~> Class['::systemd::journald::service']
}
