systemd::sysvwrapper { "dockercontainer_${container_id}":
  initscript => "/etc/init.d/dockercontainer_${container_id}",
  restart    => 'always',
}
