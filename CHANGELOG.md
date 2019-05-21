# CHANGELOG

## 0.2.5

* added **BindsTo** option - fixes [issue 118](https://github.com/NTTCom-MS/eyp-systemd/issues/118)
* fixed permissions on the forge build - fixes [issue 132](https://github.com/NTTCom-MS/eyp-systemd/issues/132)

## 0.2.4

* BUGFIX: changed name for service dropins - thanks to [ArVincentr](https://github.com/ArVincentr) for this [PR-135](https://github.com/NTTCom-MS/eyp-systemd/pull/135)

## 0.2.3

* BUGFIX: changed unsafe default values for service dropin - thanks to [ArVincentr](https://github.com/ArVincentr) for this [PR-133](https://github.com/NTTCom-MS/eyp-systemd/pull/133)

## 0.2.2

* Added support for RHEL8 and Fedora 29 and 30

## 0.2.1

* added **StandardInput** to **systemd::service** and **systemd::service::dropin**
* added variables to **systemd::socket**:
  - ListenDatagram
  - Accept
* added managed variables to defines:
  - service
  - service dropin
  - socket
  - target
  - timer
* improved acceptance testing

## 0.2.0

* Added **puppetlabs/concat** as a dependency
* Added **systemd::target** support - thanks to [ArVincentr](https://github.com/ArVincentr) for this [PR-126](https://github.com/NTTCom-MS/eyp-systemd/pull/126) partially fixing [issue 123](https://github.com/NTTCom-MS/eyp-systemd/issues/123)
* **INCOMPATIBLE CHANGES**: safer defaults for:
  - **systemd::timesyncd**: root_distance_max_sec, poll_interval_min_sec and poll_interval_max_sec changed to undef by default
  - **logind** is no longer managed by default
  - syslog related settings not set by default on **system::service**

## 0.1.51

* Removed **validate_** functions

## 0.1.50

* Add array support for **ExecReload** - thanks to [bagasse](https://github.com/bagasse) for this [PR-121](https://github.com/NTTCom-MS/eyp-systemd/pull/121)
* Add **PartOf** parameter for service units - thanks to [ArVincentr](https://github.com/ArVincentr) for this [PR-122](https://github.com/NTTCom-MS/eyp-systemd/pull/122)

## 0.1.49

* Quick reference for **systemd::timer** - thanks to [towo](https://github.com/towo) for this [PR-119](https://github.com/NTTCom-MS/eyp-systemd/pull/119)
* Add **TasksMax** parameter for service units - thanks to [v4ld3r5](https://github.com/v4ld3r5) for this [PR-117](https://github.com/NTTCom-MS/eyp-systemd/pull/117)

## 0.1.48

* Allow **logind.conf** to be unmanaged - thanks to [davidnewhall](https://github.com/davidnewhall) for this [PR-106](https://github.com/NTTCom-MS/eyp-systemd/pull/106)
* Fix dependency circle with puppet 4 - thanks to [TuningYourCode](https://github.com/TuningYourCode) for this [PR-105](https://github.com/NTTCom-MS/eyp-systemd/pull/105)

## 0.1.47

* added OpenSuSE support
* added Fedora support

## 0.1.46

* Fix ExecStart in dropin - thanks to [bagasse](https://github.com/bagasse) for this [PR-89](https://github.com/NTTCom-MS/eyp-systemd/pull/89)

## 0.1.45

* added CPUQuota support - thanks to [oleg-glushak](https://github.com/oleg-glushak) for this [PR-95](https://github.com/NTTCom-MS/eyp-systemd/pull/95), it have been marged with some changes using [PR-96](https://github.com/NTTCom-MS/eyp-systemd/pull/96)

## 0.1.44

* added timesyncd support via class **systemd::timesyncd**

## 0.1.43

* added Ubuntu 18.04 support
* added revolved support via class **systemd::resolved**

## 0.1.42

* Add journald under puppet management - thanks to [fraenki](https://github.com/fraenki) for this [PR-84](https://github.com/NTTCom-MS/eyp-systemd/pull/84), it have been marged with some changes using [PR-87](https://github.com/NTTCom-MS/eyp-systemd/pull/87)

## 0.1.41

* changed default setting **kill_user_processes** to false, it was breaking compatibility on some systems
* renamed **alias** to **service_alias** in **systemd::service** and **systemd::service::dropin**

## 0.1.40

* added **Alias**, **Also** and **DefaultInstance** for **systemd::service** and **systemd::service::dropin**

## 0.1.39

* logind.conf is now managed via **systemd::logind** with a lot of new options - thanks to [cedef](https://github.com/cedef) for this [PR-59](https://github.com/NTTCom-MS/eyp-systemd/pull/59), it have been marged with some changes using [PR-81](https://github.com/NTTCom-MS/eyp-systemd/pull/81)

## 0.1.38

* Add syslog facility, memlock and core limits to service template - thanks to [davidnewhall](https://github.com/davidnewhall) for this [PR-53](https://github.com/NTTCom-MS/eyp-systemd/pull/53)
* Manage /etc/systemd/system.conf file - thanks to [cedef](https://github.com/cedef) for this [PR-58](https://github.com/NTTCom-MS/eyp-systemd/pull/58)

## 0.1.37

* Modified **systemd::service::dropin** to allow multiple drop in files per service as suggested in [Issue 49](https://github.com/NTTCom-MS/eyp-systemd/issues/49) by [cedef](https://github.com/cedef)

## 0.1.36

* added ability to **systemd::service** to use OnFailure - thanks to [TuningYourCode](https://github.com/TuningYourCode) for this [PR-65](https://github.com/NTTCom-MS/eyp-systemd/pull/65)
* Added SuccessExitStatus and KillSignal to **systemd::service** - thanks to [alquez](https://github.com/alquez) for this [PR-63](https://github.com/NTTCom-MS/eyp-systemd/pull/63)
* added support for Debian 9 - thanks to [cedef](https://github.com/cedef) for this [PR-60](https://github.com/NTTCom-MS/eyp-systemd/pull/60)
* modified service template to be able to be used in **systemd::service::dropin**
* [Issue 55](https://github.com/NTTCom-MS/eyp-systemd/issues/55) Restart default value conflicts with oneshot services, changed default value to **undef**
* [Issue 54](https://github.com/NTTCom-MS/eyp-systemd/issues/54) Added exec *systemctl daemon-reload* because *systemctl reload* is a valid command and it may be confusing. *systemctl reload* will be removed in the **0.2.0** release

## 0.1.35

* execstart for **systemd::service** is no longer mandatory
* added dropinfile support using **systemd::service::dropin** - thanks to [oOHenry](https://github.com/oOHenry) for this [PR-57](https://github.com/NTTCom-MS/eyp-systemd/pull/57)

## 0.1.34

* for puppet4, changed include for contain as suggested by [steveniemitz](https://github.com/NTTCom-MS/eyp-systemd/issues/35)
* **systemd::timer** camelcase + nil values - thanks to [cedef](https://github.com/cedef) for this [PR-47](https://github.com/NTTCom-MS/eyp-systemd/pull/47)
* added Rubocop to enhance ruby files code quality - thanks to [cedef](https://github.com/cedef) for this [PR-48](https://github.com/NTTCom-MS/eyp-systemd/pull/48)

## 0.1.33

* added **wait_time_on_startup** to **systemd::sysvwrapper**

## 0.1.32

* added include to **systemd::sysvwrapper**

## 0.1.31

* make **systemd::sysvwrapper** more generic allowing init scripts outside /etc/init.d

## 0.1.30

* added ArchLinux support
* added **systemd::timer** - thanks to [func0der](https://github.com/func0der) for this [PR-44](https://github.com/NTTCom-MS/eyp-systemd/pull/44), merged with some changes in [PR-46](https://github.com/NTTCom-MS/eyp-systemd/pull/46)

## 0.1.29

* added **description** to **systemd::socket**

## 0.1.28

* added KillMode to **systemd::service**

## 0.1.27

* added standard_error and standard_output variables to **systemd::service** (default to syslog, keeping compatibility)

## 0.1.26

* added ExecStartPost options to **systemd::service**
* allow multiple commands for **ExecStart** and **ExecStop** (based on [PR-32](https://github.com/NTTCom-MS/eyp-systemd/pull/32))

## 0.1.25

* added minimal socket support

## 0.1.24

* acceptance testing skeleton

## 0.1.23

* Added StartLimitInterval and StartLimitBurst - thanks to [steveniemitz](https://github.com/steveniemitz) for this PR
* Fixed UMask casing and removed redundant default - thanks to [steveniemitz](https://github.com/steveniemitz) for this PR

## 0.1.22

* added to **systemd::service**
  * environment_files - thanks to [oOHenry](https://github.com/oOHenry) for this PR
  * umask
  * nice
  * oom_score_adjust

## 0.1.21

* added SLES12 support
* added to **systemd::service**:
  * working_directory
  * root_directory

## 0.1.20

* added to **systemd::service**:
  * restart_sec
  * private_tmp
  * limit_nproc
  * limit_nice
* enhanced restart validation

## 0.1.19

* added service variables:
  * permissions_start_only
  * execstartpre
  * timeoutstartsec
  * timeoutstopsec
  * timeoutsec
  * restart_prevent_exit_status
  * limit_nofile
  * runtime_directory
  * runtime_directory_mode

## 0.1.18

* added service ordering variables:
  * wants
  * before
  * after
  * requires
  * conflicts
* added **wantedby** and **requiredby**

## 0.1.17

* added **env_vars** - thanks to [dzmitryv](https://github.com/dzmitryv) for this PR
* added options:
  * after
  * remain_after_exit
  * type
  * execreload

## 0.1.16

* added description
* added Ubuntu 16.04

## 0.1.14

* added **eyp_systemd_available** fact
* added configurable check time for sysv wrapper

## 0.1.12

* added sysvwrapper for sysv init scripts without PIDFILE

## 0.1.11

*  pidfile for systemd::service

## 0.1.10

* support for Ubuntu 16.04 and Debian 8
