# CHANGELOG

## 0.1.37

* Modified **systemd::service::dropin** to allow multiple drop in files per service as suggested in [Issue 49](https://github.com/NTTCom-MS/eyp-systemd/issues/49) by [cedef](https://github.com/cedef)
* Drop in directory created by default in **systemd::service**

## 0.1.36

* added ability to **systemd::service** to use OnFailure  - thanks to [TuningYourCode](https://github.com/TuningYourCode) for this [PR-65](https://github.com/NTTCom-MS/eyp-systemd/pull/65)
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
