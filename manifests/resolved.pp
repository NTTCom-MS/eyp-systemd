class systemd::resolved (
  Boolean $manage_service = true,
  Boolean $manage_docker_service = true,
  Enum['running', 'stopped'] $service_ensure = 'running',
  Boolean $service_enable = true,
  Array $dns = [],
  Array $fallback_dns = [],
  Boolean $dns_stub_listener = true,
  Boolean $dnssec = false,
  Boolean $cache = true,
) {

  contain '::systemd::resolved::config'
  contain '::systemd::resolved::service'

  Class['::systemd::resolved::config']
  ~> Class['::systemd::resolved::service']
}
