# systemd 🎗️

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
* service,socket and timer definitions (sys-v wrapper also available)
* **logind.conf** management (default behaviour is to **disable RemoveIPC** by default)
* `/etc/systemd/system.conf` (systemd manager configuration)

For systemd related questions please refer to:

* [Service](https://www.freedesktop.org/software/systemd/man/systemd.service.html)
* [Unit](https://www.freedesktop.org/software/systemd/man/systemd.exec.html)

## Setup

### What systemd affects

- Creates service definitions: **/etc/systemd/system/${servicename}.service**
- Creates socket definitions: **/etc/systemd/system/${servicename}.socket**
- Creates timer definitions: **/etc/systemd/system/${servicename}.timer**
- Creates drop-in definitions: **/etc/systemd/system/${servicename}/${dropin_order}-${dropin_name}.service**
- Creates systemd/sys-v compatibility scripts
- Manages **/etc/systemd/logind.conf**
- Manages **/etc/systemd/journald.conf**
- Manages **/etc/systemd/timesyncd.conf**
- Manages **/etc/systemd/resolved.conf**

### Setup Requirements

This module requires pluginsync enabled

### Basic examples
---
#### Systemd Service

```puppet
systemd::service { 'kibana':
  execstart => "${basedir}/${productname}/bin/kibana",
}
```

This is going to create the following service:

```
[Unit]

[Service]
ExecStart=/usr/bin/kibana
Restart=always
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=kibana
User=root
Group=root
PermissionsStartOnly=false
PrivateTmp=no

[Install]
WantedBy=multi-user.target
```

#### Service overrides(dropin):
```puppet
systemd::service::dropin { 'ceph-disk@':
  env_vars => ['CEPH_DISK_TIMEOUT=3000'],
}
```

This is going to create the following overrride file:

```bash
# cat /etc/systemd/system/ceph-disk@.service.d/override.conf:
[Service]
Environment=CEPH_DISK_TIMEOUT=3000
```

Please be aware this module defaults (documented in the [reference](#reference) section) differ from systemd's defaults

#### Setup specific systemd manager directives

```puppet
class { 'systemd::system':
  runtime_watchdog_sec  => '40',
  shutdown_watchdog_sec => '2min',
}
```

## Usage
---
### Systemd Service:
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

```bash
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
```bash
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
### Systemd Service Overrides:

```puppet
systemd::service::dropin { 'node_exporter':
  user    => 'monitoring',
  restart => 'on-failure',
}
```

This is going to create the following overrride file:

```bash
# cat /etc/systemd/system/node_exporter.service.d/override.conf:
[Service]
Restart=on-failure
User=monitoring
```

## Reference
---
### classes

#### systemd

base class for systemd reload management

#### systemd::timesyncd

* **manage_service**:        (default: true)
* **manage_docker_service**: (default: true)
* **service_ensure**:        (default: running)
* **service_enable**:        (default: true)
* **servers**:               (default: [])
* **fallback_servers**:      (default: [])
* **root_distance_max_sec**: (default: 5)
* **poll_interval_min_sec**: (default: 32)
* **poll_interval_max_sec**: (default: 2048)

#### systemd::resolved

* **manage_service**:        (default: true)
* **manage_docker_service**: (default: true)
* **service_ensure**:        (default: running)
* **service_enable**:        (default: true)
* **dns**:                   (default: [])
* **fallback_dns**:          (default: [])
* **dns_stub_listener**:     (default: true)
* **dnssec**:                (default: false)
* **cache**:                 (default: true)

#### systemd::logind

/etc/systemd/logind.conf management:

* **handle_hibernate_key**:            (default: 'hibernate')
* **handle_lid_switch**:               (default: suspend')
* **handle_lid_switch_docked**:        (default: ignore')
* **handle_power_key**:                (default: poweroff')
* **handle_suspend_key**:              (default: suspend')
* **hibernate_key_ignore_inhibited**:  (default: false)
* **holdoff_timeout_sec**:             (default: 30)
* **idle_action**:                     (default: ignore')
* **idle_action_sec**:                 (default: 30min')
* **inhibit_delay_max_sec**:           (default: 5)
* **inhibitors_max**:                  (default: 8192)
* **kill_exclude_users**:              (default: ['root'])
* **kill_only_users**:                 (default: [])
* **kill_user_processes**:             (default: true)
* **lid_switch_ignore_inhibited**:     (default: true)
* **n_auto_vts**:                      (default: 6)
* **power_key_ignore_inhibited**:      (default: false)
* **remove_ipc**:                      (default: false)
* **reserve_vt**:                      (default: 6)
* **runtime_directory_size**:          (default: 10%')
* **sessions_max**:                    (default: 8192)
* **suspend_key_ignore_inhibited**:    (default: false)
* **user_tasks_max**:                  (default: 33%')

#### systemd::journald

systemd-journald is a system service that collects and stores logging data

* **compress**: If enabled (the default), data objects that shall be stored in the journal and are larger than the default threshold of 512 bytes are compressed before they are written to the file system. It can also be set to a number of bytes to specify the compression threshold directly. Suffixes like K, M, and G can be used to specify larger units. (default: true)
* **forward_to_console**:    (default: false)
* **forward_to_kmsg**:       (default: false)
* **forward_to_syslog**:     (default: true)
* **forward_to_wall**:       (default: true)
* **max_file_sec**:          (default: 1month)
* **max_level_console**:     (default: info)
* **max_level_kmsg**:        (default: notice)
* **max_level_store**:       (default: debug)
* **max_level_syslog**:      (default: debug)
* **max_level_wall**:        (default: emerg)
* **max_retention_sec**:     (default: undef)
* **rate_limit_burst**:      (default: 1000)
* **rate_limit_interval**:   (default: 30s)
* **runtime_keep_free**:     (default: undef)
* **runtime_max_files_size**: (default: undef)
* **runtime_max_use**:       (default: undef)
* **seal**: If enabled (the default), and a sealing key is available (as created by journalctl(1)'s --setup-keys command), Forward Secure Sealing (FSS) for all persistent journal files is enabled (default: true)
* **split_mode**:            (default: uid)
* **storage**: Controls where to store journal data. One of "volatile", "persistent", "auto" and "none" (default: auto)
* **sync_interval_sec**:     (default: 5m)
* **system_keep_free**:      (default: undef)
* **system_max_file_size**:  (default: undef)
* **system_max_use**:        (default: undef)
* **tty_path**:              (default: /dev/console)

### defines

#### systemd::service

* **execstart**: command to start daemon (default: undef)
* **execstop**: command to stop daemon (default: undef)
* **execreload**: commands or scripts to be executed when the unit is reloaded (default: undef)
* **restart**: restart daemon if crashes. Takes one of no, on-success, on-failure, on-abnormal, on-watchdog, on-abort, or always (default: undef)
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
* **working_directory**: Takes a directory path relative to the service's root directory specified by RootDirectory= (default: undef)
* **root_directory**: Sets the root directory for executed processes, with the chroot(2) system call (default: undef)
* **environment_files**: Similar to **env_vars** but reads the environment variables from a text file. The text file should contain new-line-separated variable assignments. Empty lines, lines without an "=" separator, or lines starting with ; or # will be ignored, which may be used for commenting. A line ending with a backslash will be concatenated with the following one, allowing multiline variable definitions (default: undef)
* **umask**: Controls the file mode creation mask. Takes an access mode in octal notation. (default: undef)
* **nice**: Sets the default nice level (scheduling priority) for executed processes. Takes an integer between -20 *highest priority* and 19 *lowest priority* (default: undef)
* **oom_score_adjust**: Sets the adjustment level for the **Out-Of-Memory killer** for executed processes. Takes an integer between -1000 *to disable OOM killing* and 1000 *to make killing of this process under memory pressure very likely* (default: undef)
* **startlimitinterval**:  Configures the checking interval (default: undef)
* **startlimitburst**: Configures how many starts per interval are allowed (default: undef)
* **killmode**: Specifies how processes of this unit shall be killed. One of control-group, process, mixed, none. (default: undef)
* **cpuquota**: Assign the specified CPU time quota to the processes executed. Takes a percentage value, suffixed with "%". The percentage specifies how much CPU time the unit shall get at maximum, relative to the total CPU time available on one CPU (default: undef)

#### systemd::service::dropin

Has the same options as **systemd::service** plus the following options for the dropin itself management:
* **dropin_order**: dropin priority - part of the filename, only useful for multiple dropin files (default: 99)
* **dropin_name**: dropin name (default: override)

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

1. Fork it using the development fork: [jordiprats/eyp-systemd](https://github.com/jordiprats/eyp-systemd)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
