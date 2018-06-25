define systemd::timer (
  String $unit,
  Boolean $persistent = false,
  Boolean $wake_system = false,
  Boolean $remain_after_elapse = true,
  Optional[String] $description = undef,
  Optional[String] $documentation = undef,
  Optional[String] $on_active_sec = undef,
  Optional[String] $on_boot_sec = undef,
  Optional[String] $on_startup_sec = undef,
  Optional[String] $on_unit_active_sec = undef,
  Optional[String] $on_unit_inactive_sec = undef,
  Optional[String] $on_calendar = undef,
  Optional[String] $accuracy_sec = undef,
  Optional[Integer] $randomized_delay_sec = undef,
  Optional[Array] $wantedby = undef,
  Optional[Array] $requiredby = undef,
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
