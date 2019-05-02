define systemd::service::target ( 
                                  $targetname   = $name, 
                                  $description  = undef,
                                  $allowisolate = undef,
                                  
  ) {


  if versioncmp($::puppetversion, '4.0.0') >= 0
    {
      contain ::systemd
    }
    else
    {
      include ::systemd
    }
    
  file { "/etc/systemd/system/${targetname}.target":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/target.erb"),
    notify  => Exec['systemctl daemon-reload'],
  }
