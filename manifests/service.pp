define systemd::service (
                          $execstart,
                          $execstop=undef,
                          $restart='always',
                          $user='root',
                          $group='root',
                          $servicename=$name,
                          $forking=false,
                        ) {
  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  if ! defined(Class['systemd'])
  {
    fail('You must include the systemd base class before using any systemd defined resources')
  }

  validate_re($restart, [ '^always$', '^no$'], "Not a supported restart type: ${restart}")

  file { "/etc/systemd/system/${servicename}.service":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/service.erb"),
    notify  => Exec['systemctl reload'],
  }

}
