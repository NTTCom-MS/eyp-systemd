define systemd::target(
                        $ensure                          = 'present',
                        $target_name                     = $name,
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
                      ) {
  include ::systemd

  concat { "/etc/systemd/system/${target_name}.target":
    ensure => $ensure,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Exec['systemctl daemon-reload'],
  }

  concat::fragment {"target ${target_name} unit":
    target  => "/etc/systemd/system/${target_name}.target",
    order   => '00',
    content => template("${module_name}/section/unit.erb"),
  }
}
