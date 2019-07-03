class systemd::params {

  case $::osfamily
  {
    'redhat' :
    {
      case $::operatingsystem
      {
        'Fedora':
        {
          case $::operatingsystemrelease
          {
            /^1[5-9].*$/:
            {
            }
            /^[23][0-9].*$/:
            {
            }
            default: { fail('Unsupported RHEL/CentOS version!')  }
          }
        }
        default:
        {
          case $::operatingsystemrelease
          {
            /^[78].*$/:
            {
            }
            default: { fail('Unsupported RHEL/CentOS version!')  }
          }
        }
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
            /^10.*$/:
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
        /^1[235].*/:
        {
        }
        /^42.*/:
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
