class systemd::logind(
                        $handle_hibernate_key            = 'hibernate',
                        $handle_lid_switch               = 'suspend',
                        $handle_lid_switch_docked        = 'ignore',
                        $handle_power_key                = 'poweroff',
                        $handle_suspend_key              = 'suspend',
                        $hibernate_key_ignore_inhibited  = false,
                        $holdoff_timeout_sec             = 30,
                        $idle_action                     = 'ignore',
                        $idle_action_sec                 = '30min',
                        $inhibit_delay_max_sec           = 5,
                        $inhibitors_max                  = 8192,
                        $kill_exclude_users              = ['root'],
                        $kill_only_users                 = [],
                        $kill_user_processes             = true,
                        $lid_switch_ignore_inhibited     = true,
                        $n_auto_vts                      = 6,
                        $power_key_ignore_inhibited      = false,
                        $remove_ipc                      = yesno2bool($systemd::removeipc),
                        $reserve_vt                      = 6,
                        $runtime_directory_size          = '10%',
                        $sessions_max                    = 8192,
                        $suspend_key_ignore_inhibited    = false,
                        $user_tasks_max                  = '33%',
                      ) {

  include ::systemd

  validate_bool($hibernate_key_ignore_inhibited, $kill_user_processes,
                $lid_switch_ignore_inhibited, $power_key_ignore_inhibited,
                $remove_ipc, $suspend_key_ignore_inhibited)

  validate_array($kill_exclude_users, $kill_only_users)

  validate_integer([$inhibitors_max, $n_auto_vts, $reserve_vt])

  validate_re($handle_hibernate_key, ['^ignore$', '^poweroff$', '^reboot$',
                                      '^halt$', '^kexec$', '^suspend$', '^hibernate$',
                                      '^hybrid-sleep$', '^lock$'])

  validate_re($handle_hibernate_key, ['^ignore$', '^poweroff$', '^reboot$',
                                      '^halt$', '^kexec$', '^suspend$', '^hibernate$',
                                      '^hybrid-sleep$', '^lock$'])

  validate_re($handle_lid_switch, ['^ignore$', '^poweroff$', '^reboot$',
                                    '^halt$', '^kexec$', '^suspend$',
                                    '^hibernate$', '^hybrid-sleep$', '^lock$'])

  validate_re($handle_lid_switch_docked, ['^ignore$', '^poweroff$',
                                          '^reboot$', '^halt$', '^kexec$',
                                          '^suspend$', '^hibernate$',
                                          '^hybrid-sleep$', '^lock$'])

  validate_re($handle_power_key, ['^ignore$', '^poweroff$', '^reboot$',
                                  '^halt$', '^kexec$', '^suspend$',
                                  '^hibernate$', '^hybrid-sleep$', '^lock$'])

  validate_re($handle_suspend_key, ['^ignore$', '^poweroff$', '^reboot$',
                                    '^halt$', '^kexec$', '^suspend$',
                                    '^hibernate$', '^hybrid-sleep$', '^lock$'])


  file { '/etc/systemd/logind.conf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/logind.erb"),
    notify  => Exec['systemctl reload'],
  }
}
