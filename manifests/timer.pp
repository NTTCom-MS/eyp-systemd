define systemd::timer (
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
                        $description          = undef,
                        $documentation        = undef,
                        $wantedby             = [],
                        $requiredby           = [],
                      ) {
  # Timer section
  if ($persistent) {
    validate_legacy(Boolean, 'validate_bool', $persistent)
  }
  if ($wake_system) {
    validate_legacy(Boolean, 'validate_bool', $wake_system)
  }
  if ($remain_after_elapse) {
    validate_legacy(Boolean, 'validate_bool', $remain_after_elapse)
  }

  # Unit section
  if ($documentation) {
    validate_legacy('Optional[String]', 'validate_re', $documentation,
      [ '^https?://', '^file:', '^info:', '^man:']
    )
  }

  # Install section
  validate_legacy(Array, 'validate_array', $wantedby)
  validate_legacy(Array, 'validate_array', $requiredby)

  if ($persistent != undef and $persistent == true and $on_calendar == undef) {
    fail('$persistent being "true" only works with $on_calendar being set.')
  }

  file { "/etc/systemd/system/${title}.timer":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/timer.erb"),
    notify  => Exec['systemctl daemon-reload'],
  }
}
