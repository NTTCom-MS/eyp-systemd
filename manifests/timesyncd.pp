class systemd::timesyncd(
  Boolean $manage_service = true,
  Boolean $manage_docker_service = true,
  Enum['running', 'stopped']$service_ensure = 'running',
  Boolean $service_enable = true,
  Array $servers = [],
  Array $fallback_servers = [],
  Integer $root_distance_max_sec = '5',
  Integer $poll_interval_min_sec = '32',
  Integer $poll_interval_max_sec = '2048',
) {

  contain '::systemd::timesyncd::config'
  contain '::systemd::timesyncd::service'

  Class['::systemd::timesyncd::config']
  ~> Class['::systemd::timesyncd::service']
}
