# TODO:
# https://manpages.debian.org/stretch/systemd/tmpfiles.d.5.en.html
#
###################################################################
#
# /etc/tmpfiles.d/*.conf
#
# /run/tmpfiles.d/*.conf
#
# /usr/lib/tmpfiles.d/*.conf
#
# Type Path        Mode UID  GID  Age Argument
#
define systemd::tmpfile (
                          $type,
                          $path,
                          $mode        = '-',
                          $user        = '-',
                          $group       = '-',
                          $group       = '-',
                          $argument    = undef,
                          $item_name   = $name,
                          $order       = '42',
                          $description = undef,
                        ) {
  if(!defined(Concat["/etc/tmpfiles.d/${item_name}.conf"]))
  {
    concat { "/etc/tmpfiles.d/${item_name}.conf":
      ensure => 'present',
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      # notify =>
    }

    concat::fragment { "tmpfiles.d ${item_name} header":
      target  => "/etc/tmpfiles.d/${item_name}.conf",
      order   => "0-00",
      content => "# Type Path        Mode UID  GID  Age Argument\n\n",
    }

  }

  concat::fragment { "tmpfiles.d ${item_name} $path":
    target  => "/etc/tmpfiles.d/${item_name}.conf",
    order   => "1-${order}",
    content => template("${module_name}/tmpfiles/tmpfile.erb"),
  }

}
