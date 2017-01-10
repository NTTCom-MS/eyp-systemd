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
    * [Contributing](#contributing)

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

add service dependency:

```puppet
systemd::service { 'oracleasm':
  description       => 'Load oracleasm Modules',
  after             => 'iscsi.service',
  type              => 'oneshot',
  remain_after_exit => true,
  execstart         => '/usr/sbin/service oracleasm start_sysctl',
  execstop          => '/usr/sbin/service oracleasm stop_sysctl',
  execreload        => '/usr/sbin/service oracleasm restart_sysctl',
}
```

env_vars usage example:

```puppet
systemd::service { 'tomcat7':
  user        => 'tomcat',
  group       => 'tomcat',
  execstart   => '/apps/tomcat/bin/startup.sh',
  execstop    => '/apps/tomcat/bin/startup.sh',
  forking     => true,
  description => 'Apache Tomcat Web Application Container',
  after       => 'network.target',
  restart     => 'no',
  env_vars    => ['"JAVA_OPTS=-Xms2048m -Xmx2048m -XX:MaxMetaspaceSize=512m"',
                  '"CATALINA_PID=/apps/tomcat/logs/catalina.pid"'],
}
```

## Reference

### classes

#### systemd

* **removeipc**: IPC deletion on user logout (default: no)

### defines

#### systemd::service

* **execstart**: command to start daemon
* **execstop**: command to stop daemon (default: undef)
* **execreload**: commands or scripts to be executed when the unit is reloaded (default: undef)
* **restart**: restart daemon if crashes (default: always)
* **user**: username to use (default: root)
* **group**: group to use (default: root)
* **servicename**: service name (default: resource's name)
* **forking**: expect fork to background (default: false)
* **pid_file**: PIDFile specifies a stable PID for the main process of the service (default: undef)
* **description**: A meaningful description of the unit. This text is displayed for example in the output of the systemctl status command (default: undef)
* **after**: Defines the order in which units are started (default: undef)
* **remain_after_exit**: If set to True, the service is considered active even when all its processes exited. (default: undef)
* **type**: Configures the unit process startup type that affects the functionality of ExecStart and related options (default: undef)
* **env_vars**: array of environment variables (default: undef)

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
