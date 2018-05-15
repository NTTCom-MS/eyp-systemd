class systemd::resolved (
                          $manage_service        = true,
                          $manage_docker_service = true,
                          $service_ensure        = 'running',
                          $service_enable        = true,
                          $dns                   = [],
                          $fallback_dns          = [],
                          $dns_stub_listener     = true,
                          $dnssec                = false,
                          $cache                 = true,
                        ) inherits systemd::params {


  class { '::systemd::resolved::config': } ~>
  class { '::systemd::resolved::service': } ->
  Class['::systemd::resolved']
}
