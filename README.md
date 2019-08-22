# systemd

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
    * [TODO](#todo)
    * [Contributing](#contributing)

## Overview

management of systemd services, services dropins, sockets, timers, timesyncd, journald, logind and resolved daemons

## Module Description

This module manages:
* Creation of services, services dropins, sockets and timers definitions (An optional sys-v wrapper is also available)
* Other supported configuration files can be managed by puppet by including the appropriate class

For systemd related questions please refer to [systemd man pages](https://www.freedesktop.org/software/systemd/man/index.html)

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

This module is compatible for puppet 3.8 and newer versions, requires pluginsync enabled for puppet <=4.0

Compatibility for puppet 3.8 will be kept at least until the next major release

### Basic examples

You can also find some puppet code on the examples folder with some configurations intended for testing

#### Systemd Service

```puppet
systemd::service { 'simpledemo':
  execstart => "/usr/bin/simpledemo",
}
```

As a reference, this is going to create the following service:

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

This definition creates the following service dropin:

```bash
# cat /etc/systemd/system/ceph-disk@.service.d/override.conf:
[Service]
Environment=CEPH_DISK_TIMEOUT=3000
```

Please be aware this module defaults (documented in the [reference](#reference) section) can differ from systemd's defaults in some aspects

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

Dependencies between systemd services using systemd directives like **after** in the following example:

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

Add environments variables using **env_vars**:

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

System-V compatibility mode. A slightly different versions of the following code is used in **eyp-docker** to ensure a given container is running on CentOS 7

```puppet
file { "/etc/init.d/dockercontainer_${container_id}":
  ensure  => 'present',
  owner   => 'root',
  group   => 'root',
  mode    => '0755',
  content => file("${module_name}/container_init.sh"),
}

systemd::sysvwrapper { "dockercontainer_${container_id}":
  initscript => "/etc/init.d/dockercontainer_${container_id}",
  notify     => Service["dockercontainer_${container_id}"],
  before     => Service["dockercontainer_${container_id}"],
}

service { "dockercontainer_${container_id}":
  ensure  => 'running',
  enable  => true,
  require => File["/etc/init.d/dockercontainer_${container_id}"],
}
```

This creates the following files on the system:

systemd service definition:

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

A control script:
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

Once the service is started, this script checks, in this example ma's status, reporting it back to systemd:

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

This is going to create the following override file:

```bash
# cat /etc/systemd/system/node_exporter.service.d/override.conf:
[Service]
Restart=on-failure
User=monitoring
```

### systemd::mount example

```
systemd::mount { '/boot/efi':
  what    => '/dev/sda1',
  type    => 'vfat',
  options => [ 'rw', 'relatime', 'fmask=0077', 'dmask=0077', 'codepage=437', 'iocharset=iso8859-1', 'shortname=mixed', 'errors=remount-ro' ],
}
```

/boot/efi management using systemd:

```
jprats@croscat:~/git/eyp-systemd$ cat /etc/systemd/system/boot-efi.mount
[Unit]
[Install]
WantedBy=multi-user.target
[Mount]
What=/dev/sda1
Where=/boot/efi
Type=vfat
Options=rw,relatime,fmask=0077,dmask=0077,codepage=437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro
```

status output:

```
jprats@croscat:~/git/eyp-systemd$ systemctl status boot-efi.mount
● boot-efi.mount - /boot/efi
   Loaded: loaded (/etc/systemd/system/boot-efi.mount; disabled; vendor preset: enabled)
   Active: active (mounted) since mar 2019-06-18 09:20:23 CEST; 1 day 4h ago
    Where: /boot/efi
     What: /dev/sda1
    Tasks: 0
   Memory: 56.0K
      CPU: 1ms

```

mount command:

```
jprats@croscat:~/git/eyp-systemd$ mount | grep sda1
/dev/sda1 on /boot/efi type vfat (rw,relatime,fmask=0077,dmask=0077,codepage=437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro)
```


## Reference
---
### classes

#### systemd

Base class for refreshing systemd on demand

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

#### systemd::mount

* **what**: Takes an absolute path of a device node, file or other resource to mount. See mount(8) for details. If this refers to a device node, a dependency on the respective device unit is automatically created. (See systemd.device(5) for more information.) This option is mandatory.
* **where**: Takes an absolute path of a directory for the mount point; in particular, the destination cannot be a symbolic link. If the mount point does not exist at the time of mounting, it is created. This string must be reflected in the unit filename. (See above.) This option is mandatory. (default: resource's name)
* **type**: Takes a string for the file system type. See mount(8) for details. This setting is optional.
* **options**: Mount options to use when mounting. This takes a comma-separated list of options. This setting is optional. Note that the usual specifier expansion is applied to this setting, literal percent characters should hence be written as "%%".
(...)

#### systemd::service

* **execstart**: command to start daemon (default: undef)
* **execstop**: command to stop daemon (default: undef)
* **execreload**: commands or scripts to be executed when the unit is reloaded, it can be either a string or an array to be specified multiple times (default: undef)
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
* **binds_to**: Configures requirement dependencies, very similar in style to Requires=. However, this dependency type is stronger: in addition to the effect of Requires= it declares that if the unit bound to is stopped, this unit will be stopped too (default: [])
* **conflicts**: A space-separated list of unit names. Configures negative requirement dependencies. If a unit has a Conflicts= setting on another unit, starting the former will stop the latter and vice versa (default: [])
* **wantedby**: Array, this has the effect that a dependency of type **Wants=** is added from the listed unit to the current unit (default: ['multi-user.target'])
* **requiredby**: Array, this has the effect that a dependency of type **Requires=** is added from the listed unit to the current unit (default: [])
* **permissions_start_only**: If **true**, the permission-related execution options, as configured with User= and similar options, are only applied to the process started with ExecStart=, and not to the various other ExecStartPre=, ExecStartPost=, ExecReload=, ExecStop=, and ExecStopPost= commands. If **false**, the setting is applied to all configured commands the same way (default: false)
* **execstartpre**: Additional commands that are executed before the command in ExecStart= Syntax is the same as for ExecStart=, except that multiple command lines are allowed and the commands are executed one after the other, serially. (default: undef)
* **execsstoppre**: Additional commands that are executed before the command in ExecStop= Syntax is the same as for ExecStop=, except that multiple command lines are allowed and the commands are executed one after the other, serially. (default: undef)
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
* **tasksmax**: Specify the maximum number of tasks that may be created in the unit. (default: undef)
* **partof**: Specify if service has dependency. Similar to Requires= When systemd stops or restarts the units listed here, the action is propagated to this unit.

#### systemd::service::dropin

Has the same options as **systemd::service** plus the following options for the dropin itself management:
* **dropin_order**: dropin priority - part of the filename, only useful for multiple dropin files (default: 99)
* **dropin_name**: dropin name (default: override)
* **purge_dropin_dir**: Flag to purge not managed dropins (default: true)

#### systemd::sysvwrapper

system-v compatibility

* **initscript**: requred (system-v init script to use)
* **servicename**: service name (default: resource's name)
* **check_time**: check interval -time between **initscript** status checks- (default: 10m)

#### systemd::timer

For a detailed explanation of all the timer settings, remember to read `systemd.timer(5)` for the full documentation.

* **on_active_sec**, **on_boot_sec**, **on_startup_sec**, **on_unit_active_sec**, **on_unit_inactive_sec**: Define monotonic timers relative to to different starting points. (default: undef)
* **on_calendar**: Defines realtime timers with calander event expressions (cf `systemd.time(7)`). (default: undef)
* **accuracy_sec**: Specify the accuracy of the timer; events are coalesced at a host-specific time between timer setting and this value. (default: undef / 1min)
* **randomized_delay_sec**: Delay the timer by a randomly selected amount of seconds between 0 and the specified value. (default: undef / 0)
* **unit**: Unit this timer refers to. (default: undef / service with same name as timer)
* **persistent**: If `'true'`, stores the state of the timer so that if the timer is re-enabled after a stop, it will run immediately if it would have run during the stop time. (default: undef / `'false'`)
* **wake_system**: If `'true'`, timer will resume the system from suspend if supported. (default: undef / `'false'`)
* **remain_after_elapse**: If `'true'`, state of a timer can still be queried after it elapsed. (default: undef / `'true'`)
* **description**: Description to use for the timer unit. (default: undef)
* **documentation**: Reference to the documentation for this unit (as per `systemd.unit(5)`). (default: undef)
* **wantedby**: List of units that *want* this unit in systemd terminolagy. (default: `[]`)
* **wantedby**: List of units that *require* this unit in systemd terminolagy. (default: `[]`)

#### systemd::target

* **description**: A meaningful description of the unit. This text is displayed for example in the output of the systemctl status command (default: undef)
* **targetname**: Used to create the target file under /etc/systemd/system/ needs to be the same name as instantiated services referenced by partof (default: undef)
* **allow_isolate**: this unit may be used with the systemctl isolate command. Otherwise, this will be refused  (default:undef)

#### systemd::socket

* **listen_stream**: (default: undef)
* **listen_datagram**: (default: undef)

## Limitations

Should work anywhere, enforced testing on **CentOS 7** and **Ubuntu 16.04** using [travis-ci](https://travis-ci.org/NTTCom-MS/eyp-systemd)

## Development

We are pushing to have acceptance testing in place, so any new feature should
have some test to check both presence and absence of any feature

### TODO

* add deeper testing to functionality
* review documentation

### Contributing

1. Fork it using the development fork: [jordiprats/eyp-systemd](https://github.com/jordiprats/eyp-systemd)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
