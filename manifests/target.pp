define systemd::target(
                        $target_name   = $name,
                        $description          = undef,
                        $documentation        = undef,
                        $wants                = [],
                        $after                = undef,
                        $after_units          = [],
                        $before_units         = [],
                        $requires             = [],
                        $conflicts            = [],
                        $on_failure           = [],
                        $partof               = undef,
                        $allow_isolate        = undef,
                      ) {
  include ::systemd

  concat { "/etc/systemd/system/${target_name}.target":
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Exec['systemctl daemon-reload'],
  }

  concat::fragment {"${target_name} unit":
    target  => "/etc/systemd/system/${target_name}.target",
    order   => '00',
    content => template("${module_name}/section/unit.erb"),
  }
}
