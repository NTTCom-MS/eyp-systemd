class systemd::journald::config inherits systemd::journald {

  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  file { '/etc/systemd/journald.conf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/journald.erb"),
  }

  if($systemd::journald::seal)
  {
    # TODO: FSS interval
    # chmod 2755 /var/log/journal/
    # [root@centos7 ~]# ls -ld /var/log/journal/
    # drwxr-sr-x+ 3 root systemd-journal 46 Apr 11 11:34 /var/log/journal/
    # [root@centos7 ~]# journalctl --interval=30s --setup-keys

    file { '/var/log/journal':
      ensure  => 'directory',
      owner   => 'root',
      group   => 'systemd-journal',
      mode    => '2755',
      require => File['/etc/systemd/journald.conf'],
    }
  }
}
