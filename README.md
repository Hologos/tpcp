# tpcp

A tool to remotely work with SAP import queue and transports.

## What does it do:

* add transport to or delete transport from import queue
* copy transport (cofile and data file) from system to system
* import transport to system
* run in bulk (multiple transports to multiple systems)

## Technical details
* written in bash
* uses jobs to run actions in parallel
* ssh multiplexing using MasterControl (all commands on one system are ran via single ssh connection)

## Usage

```bash
# ideally save it to your .bash_profile, .zlogin (etc)
export TPCP_CONFIG_FILEPATH="${HOME}/.config/tpcp/system-definition.ini"

tpcp "ABCK123456" "EFG900 MNO000 XYZ100" "CPY ADD IMP DEL"

                          CPY ADD IMP DEL
ABCK123456     EFG900      ✔   ✔  ...
               MNO000      ✖   -   -   -
               XYZ100      ✔   ✔   ✔   ✔
```

## SSH

The program expects you use ssh-agent and agent forwarding is allowed. **Password login won't work.** It also expects you already have systems added to your known_hosts. Otherwise you will get 'Host key verification failed.'. To work around that, add this to your ~/.ssh/config:

```
CanonicalizeHostname yes
CanonicalDomains <your-domain-here>
CanonicalizeMaxDots 0
CanonicalizeFallbackLocal yes

Host *.<your-domain-here>
    ForwardAgent yes
    StrictHostKeyChecking no
```
