# CHANGELOG

## 0.1.20

* added to **systemd::service**:
  * restart_sec
  * private_tmp
  * limit_nproc
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

* added **env_vars** - thanks to **dzmitryv** for this PR
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
