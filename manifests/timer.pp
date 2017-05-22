define systemd::timer (
  $onActiveSec = undef,
  $onBootSec = undef,
  $onStartupSec = undef,
  $onUnitActiveSec = undef,
  $onUnitInactiveSec = undef,
  $onCalendar = undef,
  $accuracySec = undef,
  $randomizedDelaySec = undef,
  $unit = undef,
  $persistent = undef,
  $wakeSystem = undef,
  $remainAfterElapse = undef,
  $description = undef,
  $documentation = undef,
  $wantedBy = [],
  $requiredBy = [],
) {
  # Timer section
  if ($persistent) {
    validate_bool($persistent)
  }
  if ($wakeSystem) {
    validate_bool($wakeSystem)
  }
  if ($remainAfterElapse) {
    validate_bool($remainAfterElapse)
  }

  # Unit section
  if ($documentation) {
    validate_re(
      $documentation,
      [ '^https?://', '^file:', '^info:', '^man:'],
      "Not a supported documentation uri: ${documentation} - It has to be one of 'http://', 'https://', 'file:', 'info:' or 'man:'")
  }

  # Install section
  validate_array($wantedBy)
  validate_array($requiredBy)

  if ($persistent != undef and $persistent == true and $onCalendar == undef) {
    fail('$persistent being "true" only works with $onCalendar being set.')
  }

  file { "/etc/systemd/system/${title}.timer":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/timer.erb"),
    notify  => Exec['systemctl reload'],
  }
}
