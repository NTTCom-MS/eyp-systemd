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
            /^2[0-8].*$/:
            {
            }
            default: { fail('Unsupported RHEL/CentOS version!')  }
          }
        }
        default:
        {
          case $::operatingsystemrelease
          {
            /^7.*$/:
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
        /^1[23].*|42$/:
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
