systemd::sysvwrapper { "dockercontainer_${container_id}":
  initscript => "/etc/init.d/dockercontainer_${container_id}",
  restart    => 'always',
  notify     => Service["dockercontainer_${container_id}"],
  before     => Service["dockercontainer_${container_id}"],
}
