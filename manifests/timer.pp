define systemd::timer (
  Optional[String] $on_active_sec,
  Optional[String] $on_boot_sec,
  Optional[String] $on_startup_sec,
  Optional[String] $on_unit_active_sec,
  Optional[String] $on_unit_inactive_sec,
  Optional[String] $on_calendar,
  Optional[String] $accuracy_sec,
  Optional[Integer] $randomized_delay_sec = undef,
  String $unit,
  Boolean $persistent = false,
  Boolean $wake_system = false,
  Boolean $remain_after_elapse = true,
  Optional[String] $description,
  Optional[String] $documentation,
  Array $wantedby = [],
  Array $requiredby = [],
) {
  if ($persistent == true and $on_calendar == undef)
  {
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
