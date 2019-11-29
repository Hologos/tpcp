# tpcp [![Build Status](https://travis-ci.org/Hologos/tpcp.svg?branch=master)](https://travis-ci.org/Hologos/tpcp)

A smart tool to remotely work with SAP import queue and transports.

```bash
# ideally save it to your .bash_profile, .zlogin (etc)
$ export TPCP_CONFIG_FILEPATH="${HOME}/.config/tpcp/system-definition.ini"

$ tpcp CCDK000001   AAD000 AAD100 AAT000 BBT000 BBT100 CCP000   CPY ADD IMP DEL

Loading system informations from /home/hologos/.config/tpcp/system-definition.ini.

Caching information about domain controllers.

                          CPY ADD IMP DEL
CCDK000001     AAD000     ...
               AAD100      ⧗
               AAT000      ⧗
               BBT000      ✔   ✔   ✔   ✔
               BBT100      ✔   ✖   -   -
               CCP000      -   ✔   ✖   -

Logs are located at ./tpcp-logs/20190824-173209.
```

## What does it do

* adds transport to or deletes transport from import queue
* copies transport (cofile and data file) from system to system
* imports transport to system
* runs in bulk (multiple transports to multiple systems)
* it is **smart**
  * doesn't copy transport if source system and target system are in the same transport domain
  * doesn't copy transport to multiple systems in the same transport domain

## Technical details

* written in bash
* uses jobs to run actions in parallel
* multiplexes ssh connections using MasterControl (all commands on one system are run via single ssh connection)

## Installation

**Important:** bash v4.4 and higher is required

1) Download archive from [the release page](https://github.com/Hologos/tpcp/releases) and unpack it.
2) Create system-definition.ini file (follow instructions in section [System definition ini file](#system-definition-ini-file)).
3) _Option:_ Copy completion script to /etc/bash_completion.d (or other predefined location).
4) Run the script.

### Cloning repo

**Important:** _If you forget to do `peru sync` after every update that contained changed `peru.yaml`, it can have undesirable consequences and can cause serious problems. Use at your own risk._

_Downloading files from release page is preferred._

```bash
git clone https://github.com/Hologos/tpcp
peru sync
```

## Description

### Usage

```
tpcp <transport-list> <system-list> <action-list>

    <transport-list>
        List of transport names (eg: ABCK000001).

    <system-list>
        List of system names in form of [SID][CLIENT] (eg: ABC000).

    <action-list>
        List of actions.

        Possible values:
            CPY - copy transport from source system to destination system
            ADD - add transport into import queue
            IMP - import transport into system
            DEL - delete transport from import queue

Environment variables
    TPCP_SYSTEM_FILEPATH - filepath to system definition ini file
    TPCP_LOGGER_LEVEL - level for logger library (default is I)
    TPCP_LOG_DIRPATH_ROOT - dirpath to directory (relative or absolute) where to store logs (default is .)
```

### Log files

Every run of the program generates a log directory `tpcp-logs/<datetime>`.

By default, the `tpcp-logs` is located in current working directory but the location can be changed with `TPCP_LOG_DIRPATH_ROOT` variable.

### System definition ini file

Since a hostname cannot be derived from a transport name nor from a system name, there has to be some mapping. That is what system definition ini file is for.

Each row is in form of `SID=hostname`.

```ini
; comments are allowed
ABC=abc00.your-company.corp
XYZ=svgb0hefe823.your-company.corp
```

### Host key verification

The program expects you to use ssh-agent and that agent forwarding is allowed. **Password login won't work.** It also expects you to have systems already added to your `known_hosts`, otherwise you will get 'Host key verification failed.'. To work around that, add this to your `~/.ssh/config`:

```
CanonicalizeHostname yes
CanonicalDomains <your-domain-here>
CanonicalizeMaxDots 0
CanonicalizeFallbackLocal yes

Host *.<your-domain-here>
    ForwardAgent yes
    StrictHostKeyChecking no
```

## Debugging

Debugging is done with [logger library](https://github.com/Hologos/logger). To see debug messages, set `TPCP_LOGGER_LEVEL` variable to debug value `"D"`.

In debug mode, to make it easier, the log directory is always called `debug`.

```bash
$ TPCP_LOGGER_LEVEL="D" tpcp ABCK123456   EFG900 MNO000 XYZ100   CPY ADD IMP DEL
```
