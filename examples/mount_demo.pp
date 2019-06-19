systemd::mount { '/boot/efi':
  what    => '/dev/sda1',
  type    => 'vfat',
  options => [ 'rw', 'relatime', 'fmask=0077', 'dmask=0077', 'codepage=437', 'iocharset=iso8859-1', 'shortname=mixed', 'errors=remount-ro' ],
}
