class systemd::params {

  case $::osfamily
  {
    'redhat' :
    {
      case $::operatingsystemrelease
      {
        /^7.*$/:
        {
        }
        default: { fail('Unsupported RHEL/CentOS version!')  }
      }
    }
    'Debian':
    {
      case $::operatingsystem
      {
        'Ubuntu':
        {
          case $::operatingsystemrelease
          {
            /^1[68].*$/:
            {
            }
            default: { fail("Unsupported Ubuntu version! - ${::operatingsystemrelease}")  }
          }
        }
        'Debian':
        {
          case $::operatingsystemrelease
          {
            /^[89].*$/:
            {
            }
            default: { fail("Unsupported Debian version! - ${::operatingsystemrelease}")  }
          }
        }
        default: { fail('Unsupported Debian flavour!')  }
      }
    }
    'Suse' :
    {
      case $::operatingsystemrelease
      {
        /^12.*$/:
        {
        }
        default: { fail('Unsupported Suse/OpenSuse version!')  }
      }
    }
    'Archlinux' :
    {
    }
    default  : { fail('Unsupported OS!') }
  }
}
