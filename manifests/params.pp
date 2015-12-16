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
        default: { fail("Unsupported RHEL/CentOS version!")  }
      }
    }
    default  : { fail('Unsupported OS!') }
  }
}
