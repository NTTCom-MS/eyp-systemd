class systemd::logind(
  Enum[
    'ignore', 'poweroff', 'reboot',
    'halt', 'kexec', 'suspend',
    'hibernate', 'hybrid-sleep', 'lock'
  ] $handle_hibernate_key = 'hibernate',
  Enum[
    'ignore', 'poweroff', 'reboot',
    'halt', 'kexec', 'suspend',
    'hibernate', 'hybrid-sleep', 'lock'
  ] $handle_lid_switch = 'suspend',
  Enum[
    'ignore', 'poweroff', 'reboot',
    'halt', 'kexec', 'suspend',
    'hibernate', 'hybrid-sleep', 'lock'
  ] $handle_lid_switch_docked = 'ignore',
  Enum[
    'ignore', 'poweroff', 'reboot',
    'halt', 'kexec', 'suspend',
    'hibernate', 'hybrid-sleep', 'lock'
  ] $handle_power_key = 'poweroff',
  Enum[
    'ignore', 'poweroff', 'reboot',
    'halt', 'kexec', 'suspend',
    'hibernate', 'hybrid-sleep', 'lock'
  ] $handle_suspend_key = 'suspend',
  Boolean $hibernate_key_ignore_inhibited = false,
  Integer $holdoff_timeout_sec = 30,
  Enum[
    'ignore', 'poweroff', 'reboot', 'halt', 'kexec',
    'suspend', 'hibernate', 'hybrid-sleep',
    'suspend-then-hibernate', 'lock'
  ] $idle_action = 'ignore',
  String $idle_action_sec = '30min',
  Integer $inhibit_delay_max_sec = 5,
  Integer $inhibitors_max = 8192,
  Array $kill_exclude_users = ['root'],
  Array $kill_only_users = [],
  Boolean $kill_user_processes = false,
  Boolean $lid_switch_ignore_inhibited = true,
  Integer $n_auto_vts = 6,
  Boolean $power_key_ignore_inhibited = false,
  Boolean $remove_ipc = false,
  Integer $reserve_vt = 6,
  String $runtime_directory_size = '10%',
  Integer $sessions_max = 8192,
  Boolean $suspend_key_ignore_inhibited = false,
  String $user_tasks_max = '33%',
) {

  file { '/etc/systemd/logind.conf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/logind.erb"),
    notify  => Exec['systemctl daemon-reload'],
  }
}
