class systemd::journald::service inherits systemd::journald {

  $is_docker_container_var=getvar('::eyp_docker_iscontainer')
  $is_docker_container=str2bool($is_docker_container_var)

  if( $is_docker_container==false or
      $systemd::journald::manage_docker_service)
  {
    if($systemd::journald::manage_service)
    {
      service { 'systemd-journald':
        ensure     => $systemd::journald::service_ensure,
        enable     => $systemd::journald::service_enable,
        hasstatus  => true,
        hasrestart => true,
      }
    }
  }
}
