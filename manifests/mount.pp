#
# [Unit]
# Description=Things devices
# After=network.target
#
# [Mount]
# What=172.16.24.192:/mnt/things
# Where=/mnt/things
# Type=nfs
# Options=_netdev,auto
#
# [Install]
# WantedBy=multi-user.target
#
define systemd::mount(
                        $what,
                        $where                           = $name,
                        $type                            = undef,
                        $options                         = [],
                        # install
                        $also                            = [],
                        $default_instance                = undef,
                        $service_alias                   = [],
                        $wantedby                        = [ 'multi-user.target' ],
                        $requiredby                      = [],
                        # unit
                        $description                     = undef,
                        $documentation                   = undef,
                        $wants                           = [],
                        $after                           = undef,
                        $after_units                     = [],
                        $before_units                    = [],
                        $requires                        = [],
                        $binds_to                        = [],
                        $conflicts                       = [],
                        $on_failure                      = [],
                        $partof                          = undef,
                        $allow_isolate                   = undef,
                        $condition_path_is_symbolic_link = undef,
                        $default_dependencies            = undef,
                        # global
                        $ensure                          = 'present',
                      ) {

  include ::systemd

  $mount_name = regsubst(regsubst($where, '/', '-', 'G'), '^-', '', '')

  concat { "/etc/systemd/system/${mount_name}.mount":
    ensure => $ensure,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Exec['systemctl daemon-reload'],
  }

  concat::fragment { "mount ${mount_name} unit":
    target  => "/etc/systemd/system/${mount_name}.mount",
    order   => '00',
    content => template("${module_name}/section/unit.erb"),
  }

  concat::fragment { "mount ${mount_name} install":
    target  => "/etc/systemd/system/${mount_name}.mount",
    order   => '01',
    content => template("${module_name}/section/install.erb"),
  }

  concat::fragment { "mount ${mount_name} mount":
    target  => "/etc/systemd/system/${mount_name}.mount",
    order   => '02',
    content => template("${module_name}/section/mount.erb"),
  }
}
