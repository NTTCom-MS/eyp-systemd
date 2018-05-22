class systemd::timesyncd(
                          $manage_service        = true,
                          $manage_docker_service = true,
                          $service_ensure        = 'running',
                          $service_enable        = true,
                          $servers               = [],
                          $fallback_servers      = [],
                          $root_distance_max_sec = '5',
                          $poll_interval_min_sec = '32',
                          $poll_interval_max_sec = '2048',
                        ) inherits systemd::params {


  class { '::systemd::timesyncd::config': } ~>
  class { '::systemd::timesyncd::service': } ->
  Class['::systemd::timesyncd']
}
