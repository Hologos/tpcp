# tpcp

A tool to remotely work with SAP import queue and transports.

```bash
# ideally save it to your .bash_profile, .zlogin (etc)
$ export TPCP_CONFIG_FILEPATH="${HOME}/.config/tpcp/system-definition.ini"

$ tpcp "ABCK123456" "EFG900 MNO000 XYZ100" "CPY ADD IMP DEL"

Loading system informations from /home/hologos/.config/tpcp/system-definition.ini.

                          CPY ADD IMP DEL
ABCK123456     EFG900      ✔   ✔  ...
               MNO000      ✖   -   -   -
               XYZ100      ✔   ✔   ✔   ✔

Log is located at tpcp.20190824-173209.log.
```

## What does it do

* adds transport to or deletes transport from import queue
* copies transport (cofile and data file) from system to system
* imports transport to system
* runs in bulk (multiple transports to multiple systems)

## Technical details
* written in bash
* uses jobs to run actions in parallel
* multiplexes ssh connections using MasterControl (all commands on one system are ran via single ssh connection)

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
```

### System definition ini file

Since a hostname cannot be derived from a transport name nor from a system name, there has to be some mapping. That is what system definition ini file is for.

Each row is in form of `SID=hostname`.

```ini
; comments are allowed
ABC=abc00.your-company.corp
XYZ=svgb0hefe823.your-company.corp
```

### Host key verification

The program expects you to use ssh-agent and that agent forwarding is allowed. **Password login won't work.** It also expects you to have systems already added to your known_hosts, otherwise you will get 'Host key verification failed.'. To work around that, add this to your ~/.ssh/config:

```
CanonicalizeHostname yes
CanonicalDomains <your-domain-here>
CanonicalizeMaxDots 0
CanonicalizeFallbackLocal yes

Host *.<your-domain-here>
    ForwardAgent yes
    StrictHostKeyChecking no
```

### Debugging

Debugging is done with [logger library](https://github.com/Hologos/logger). To see debug messages, set `TPCP_LOGGER_LEVEL` variable to debug value `"D"`.

```bash
$ TPCP_LOGGER_LEVEL="D" tpcp "ABCK123456" "EFG900 MNO000 XYZ100" "CPY ADD IMP DEL"
```
