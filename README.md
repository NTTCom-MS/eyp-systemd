# systemd ![status ready](https://img.shields.io/badge/status-ready-brightgreen.svg) ![doc completed](https://img.shields.io/badge/doc-completed-brightgreen.svg)

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
* service definitions (sys-v wrapper also available)
* logind.conf (disables IPC deletion on user logout)

For systemd related questions please refer to:

* [Service](https://www.freedesktop.org/software/systemd/man/systemd.service.html)
* [Unit](https://www.freedesktop.org/software/systemd/man/systemd.exec.html)

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

system-v compatibility mode:

Use case: **eyp-mcaffee** uses the following to enable the ma service on CentOS 7

```puppet
systemd::sysvwrapper { 'ma':
  initscript => '/etc/init.d/ma',
  notify     => Service['ma'],
  before     => Service['ma'],
}
```

This creates the following on the system:

systed service definition:

```
# cat /etc/systemd/system/ma.service
[Unit]

[Service]
ExecStart=/bin/bash /etc/init.d/ma.sysvwrapper.wrapper start
ExecStop=/bin/bash /etc/init.d/ma.sysvwrapper.wrapper stop
Restart=no
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=ma
User=root
Group=root
Type=forking
PIDFile=/var/run/ma.sysvwrapper.pid

[Install]
WantedBy=multi-user.target
```

control script:
```
# cat /etc/init.d/ma.sysvwrapper.wrapper
#!/bin/bash

#
# puppet managed file
#

PIDFILE=/var/run/ma.sysvwrapper.pid

case $1 in
  start)
    /etc/init.d/ma $@
    sleep 1s;
    /etc/init.d/ma.sysvwrapper.status &
    echo $! > $PIDFILE

    /etc/init.d/ma status
    exit $?
  ;;
  *)
    /etc/init.d/ma $@
    exit $?
  ;;
esac
```

process checking ma status (to be able to report status to systemd):

```
ps auxf
(...)
root     27399  0.0  0.0 113120  1396 ?        S    Jan09   0:00 /bin/bash /etc/init.d/ma.sysvwrapper.status
root      7173  0.0  0.0 107896   608 ?        S    10:34   0:00  \_ sleep 10m
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
* **restart**: restart daemon if crashes. Takes one of no, on-success, on-failure, on-abnormal, on-watchdog, on-abort, or always (default: always)
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
* **wants**: A weaker version of Requires=. Units listed in this option will be started if the configuring unit is. However, if the listed units fail to start or cannot be added to the transaction, this has no impact on the validity of the transaction as a whole (default: [])
* **before_units**: Configures ordering dependencies between units, for example, if a unit foo.service contains a setting Before=bar.service and both units are being started, bar.service's start-up is delayed until foo.service is started up (default: [])
* **after_units**: Configures ordering dependencies between units. (default: [])
* **requires**: Configures requirement dependencies on other units. If this unit gets activated, the units listed here will be activated as well. If one of the other units gets deactivated or its activation fails, this unit will be deactivated (default: [])
* **conflicts**: A space-separated list of unit names. Configures negative requirement dependencies. If a unit has a Conflicts= setting on another unit, starting the former will stop the latter and vice versa (default: [])
* **wantedby**: Array, this has the effect that a dependency of type **Wants=** is added from the listed unit to the current unit (default: ['multi-user.target'])
* **requiredby**: Array, this has the effect that a dependency of type **Requires=** is added from the listed unit to the current unit (default: [])
* **permissions_start_only**: If **true**, the permission-related execution options, as configured with User= and similar options, are only applied to the process started with ExecStart=, and not to the various other ExecStartPre=, ExecStartPost=, ExecReload=, ExecStop=, and ExecStopPost= commands. If **false**, the setting is applied to all configured commands the same way (default: false)
* **execstartpre**: Additional commands that are executed before the command in ExecStart= Syntax is the same as for ExecStart=, except that multiple command lines are allowed and the commands are executed one after the other, serially. (default: undef)
* **timeoutstartsec**:Configures the time to wait for start-up. If a daemon service does not signal start-up completion within the configured time, the service will be considered failed and will be shut down again. Takes a unit-less value in seconds, or a time span value such as "5min 20s". Pass "infinity" to disable the timeout logic (default: undef)
* **timeoutstopsec**: Configures the time to wait for stop. If a service is asked to stop, but does not terminate in the specified time, it will be terminated forcibly via SIGTERM, and after another timeout of equal duration with SIGKILL. Takes a unit-less value in seconds, or a time span value such as "5min 20s". Pass "infinity" to disable the timeout logic. (default: undef)
* **timeoutsec**: A shorthand for configuring both **TimeoutStartSec=** and **TimeoutStopSec=** to the specified value. (default: undef)
* **restart_prevent_exit_status**: Takes a list of exit status definitions that, when returned by the main service process, will prevent automatic service restarts, regardless of the restart setting configured with Restart=. Exit status definitions can either be numeric exit codes or termination signal names, and are separated by spaces. Defaults to the empty list, so that, by default, no exit status is excluded from the configured restart logic. For example: **RestartPreventExitStatus=1 6 SIGABRT** ensures that exit codes 1 and 6 and the termination signal SIGABRT will not result in automatic service restarting. This option may appear more than once, in which case the list of restart-preventing statuses is merged. If the empty string is assigned to this option, the list is reset and all prior assignments of this option will have no effect. (default: undef)
* **limit_nofile**: Limit number of File Descriptors *ulimit -n* Resource limits may be specified in two formats: either as single value to set a specific soft and hard limit to the same value, or as colon-separated pair soft:hard to set both limits individually (default: undef)
* **limit_nproc**: Limit max number of processes *ulimit -u* Resource limits may be specified in two formats: either as single value to set a specific soft and hard limit to the same value, or as colon-separated pair soft:hard to set both limits individually (default: undef)
* **limit_nice**: Nice level (default: undef)
* **runtime_directory**: Takes a list of directory names. If set, one or more directories by the specified names will be created below /run (for system services) or below $XDG_RUNTIME_DIR (for user services) when the unit is started, and removed when the unit is stopped. The directories will have the access mode specified in RuntimeDirectoryMode=, and will be owned by the user and group specified in User= and Group=. Use this to manage one or more runtime directories of the unit and bind their lifetime to the daemon runtime. The specified directory names must be relative, and may not include a "/", i.e. must refer to simple directories to create or remove. This is particularly useful for unprivileged daemons that cannot create runtime directories in /run due to lack of privileges, and to make sure the runtime directory is cleaned up automatically after use (default: undef)
* **runtime_directory_mode**: Directory mode for **runtime_directory** (default: undef)
* **restart_sec**: Configures the time to sleep before restarting a service in seconds (default: undef)
* **private_tmp**: If true, sets up a new file system namespace for the executed processes and mounts private /tmp and /var/tmp directories inside it that is not shared by processes outside of the namespace. This is useful to secure access to temporary files of the process, but makes sharing between processes via /tmp or /var/tmp impossible. If this is enabled, all temporary files created by a service in these directories will be removed after the service is stopped (default: false)


#### systemd::sysvwrapper

system-v compatibility

* **initscript**: requred (system-v init script to use)
* **servicename**: service name (default: resource's name)
* **check_time**: check interval -time between **initscript** status checks- (default: 10m)

## Limitations

Should work anywhere, tested on CentOS 7 and Ubuntu 16

## Development

We are pushing to have acceptance testing in place, so any new feature should
have some test to check both presence and absence of any feature

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
