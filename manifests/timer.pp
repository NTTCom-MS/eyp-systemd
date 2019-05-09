define systemd::timer (
                        $timer_name           = $name,
                        $on_active_sec        = undef,
                        $on_boot_sec          = undef,
                        $on_startup_sec       = undef,
                        $on_unit_active_sec   = undef,
                        $on_unit_inactive_sec = undef,
                        $on_calendar          = undef,
                        $accuracy_sec         = undef,
                        $randomized_delay_sec = undef,
                        $unit                 = undef,
                        $persistent           = undef,
                        $wake_system          = undef,
                        $remain_after_elapse  = undef,
                        # unit
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
                        # install
                        $wantedby             = [],
                        $requiredby           = [],
                      ) {
  # Timer section
  # if ($persistent)
  # {
  #   validate_bool($persistent)
  # }
  #
  # if ($wake_system)
  # {
  #   validate_bool($wake_system)
  # }
  #
  # if ($remain_after_elapse)
  # {
  #   validate_bool($remain_after_elapse)
  # }
  #
  # # Unit section
  # if ($documentation)
  # {
  #   validate_re(
  #     $documentation,
  #     [ '^https?://', '^file:', '^info:', '^man:'],
  #     "Not a supported documentation uri: ${documentation} - It has to be one of 'http://', 'https://', 'file:', 'info:' or 'man:'")
  # }

  if ($persistent != undef and $persistent == true and $on_calendar == undef)
  {
    fail('$persistent being "true" only works with $on_calendar being set.')
  }

  concat { "/etc/systemd/system/${timer_name}.timer":
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Exec['systemctl daemon-reload'],
  }

  concat::fragment { "${timer_name} unit":
    target  => "/etc/systemd/system/${timer_name}.timer",
    order   => '00',
    content => template("${module_name}/section/unit.erb"),
  }

  concat::fragment { "${timer_name} install":
    target  => "/etc/systemd/system/${timer_name}.timer",
    order   => '01',
    content => template("${module_name}/section/install.erb"),
  }

  concat::fragment { "${timer_name} timer":
    target  => "/etc/systemd/system/${timer_name}.timer",
    order   => '02',
    content => template("${module_name}/section/timer.erb"),
  }
}
