define systemd::automount (
                            $what,
                            $where            = $name,
                            $type             = undef,
                            $options          = [],
                            $directory_mode   = undef,
                            $timeout_idle_sec = undef,
                            # install
                            $also             = [],
                            $default_instance = undef,
                            $service_alias    = [],
                            $wantedby         = [ 'multi-user.target' ],
                            $requiredby       = [],
                            # unit
                            $description      = undef,
                            $documentation    = undef,
                            $wants            = [],
                            $after            = undef,
                            $after_units      = [],
                            $before_units     = [],
                            $requires         = [],
                            $binds_to         = [],
                            $conflicts        = [],
                            $on_failure       = [],
                            $partof           = undef,
                            $allow_isolate    = undef,
                            # global
                            $ensure           = 'present',
                          ) {
  if versioncmp($::puppetversion, '4.0.0') >= 0
  {
    contain ::systemd
  }
  else
  {
    include ::systemd
  }

  $mount_name = regsubst(regsubst($where, '/', '-', 'G'), '^-', '', '')

  concat { "/etc/systemd/system/${mount_name}.automount":
    ensure => $ensure,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Exec['systemctl daemon-reload'],
  }

  concat::fragment { "automount ${mount_name} unit":
    target  => "/etc/systemd/system/${mount_name}.automount",
    order   => '00',
    content => template("${module_name}/section/unit.erb"),
  }

  concat::fragment { "automount ${mount_name} install":
    target  => "/etc/systemd/system/${mount_name}.automount",
    order   => '01',
    content => template("${module_name}/section/install.erb"),
  }

  concat::fragment { "automount ${mount_name} automount":
    target  => "/etc/systemd/system/${mount_name}.automount",
    order   => '02',
    content => template("${module_name}/section/automount.erb"),
  }
}
