define systemd::target (
                        $targetname   = $name,
                        $description  = undef,
                        $allow_isolate = 'no',

  ) {


  if versioncmp($::puppetversion, '4.0.0') >= 0
    {
      contain ::systemd
    }
    else
    {
      include ::systemd
    }

  concat { "/etc/systemd/system/${targetname}.target":
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Exec['systemctl daemon-reload'],
  }

  concat::fragment {"${targetname} unit":
    target  => "/etc/systemd/system/${targetname}.target",
    order   => '00',
    content => template("${module_name}/section/unit.erb"),
  }
}
