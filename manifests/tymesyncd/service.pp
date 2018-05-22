class systemd::timesyncd::service inherits systemd::timesyncd {

  $is_docker_container_var=getvar('::eyp_docker_iscontainer')
  $is_docker_container=str2bool($is_docker_container_var)

  if( $is_docker_container==false or
      $systemd::resolved::manage_docker_service)
  {
    if($systemd::resolved::manage_service)
    {
      service { 'systemd-timesyncd':
        ensure     => $systemd::resolved::service_ensure,
        enable     => $systemd::resolved::service_enable,
        hasstatus  => true,
        hasrestart => true,
      }
    }
  }
}
