class systemd::journald::config inherits systemd::journald {

  file { '/etc/systemd/journald.conf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/journald.erb"),
  }

  if($seal)
  {
    # FSS
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

    exec { 'stop systemd-journald service for keys manipulation':
      command => 'bash -c \'systemctl stop systemd-journald; echo\'',
      unless  => 'journalctl --verify 2>&1 | grep PASS',
      require => File['/var/log/journal'],
    }

    exec { 'setup FSS keys':
      command => inline_template('bash -c \'journalctl --interval =<% = @seal_interval %> --setup-keys > /var/log/journal/.secret\''),
      unless  => 'journalctl --verify 2>&1 | grep PASS',
      require => Exec['stop systemd-journald service for keys manipulation'],
    }
  }


}
