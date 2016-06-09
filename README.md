# systemd

![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What systemd affects](#what-systemd-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with systemd](#beginning-with-systemd)
4. [Usage](#usage)
5. [Reference](#reference)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

systemd service support

## Module Description

basic systemd support implemented:
* service definitions
* logind.conf (disables IPC deletion on user logout)

## Setup

### What systemd affects

- Creates service definitions: **/etc/systemd/system/${servicename}.service**
- Manages **/etc/systemd/logind.conf**

### Setup Requirements

This module requires pluginsync enabled

### Beginning with systemd

basic example from eyp-kibana:

```puppet
systemd::service { 'kibana':
  execstart => "${basedir}/${productname}/bin/kibana",
  require   => [ Class['systemd'], File["${basedir}/${productname}/config/kibana.yml"] ],
  before => Service['kibana'],
}
```

## Usage

Put the classes, types, and resources for customizing, configuring, and doing
the fancy stuff with your module here.

## Reference

### classes

#### systemd

* **removeipc**: IPC deletion on user logout (default: no)

### defines

#### systemd::service

* **execstart**: command to start daemon
* **execstop**: command to stop daemon (if any)
* **restart**: restart daemon if crashes (default: always)
* **user**: username to use (default: root)
* **group**: group to use (default: root)
* **servicename**: service name (default: resource's name)
* **forking**: expect fork to background (default: false)

## Limitations

Should work anywhere, tested on CentOS 7

## Development

We are pushing to have acceptance testing in place, so any new feature should
have some test to check both presence and absence of any feature

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
