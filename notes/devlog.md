# BAMRU.net Development Log

Mission: package up the web assets in preparation for long-term support

Goals:
- [x] upgrade production OS to 14.04
- [ ] shared dev environment in datacenter
- [ ] working backups to dev server
- [ ] add SSL
- [ ] operations guide with 1 trained backup

Approch:
- exactly model the current tooling (ruby 1.9.3, postgres 9.3)
- move BAMRU.org calendar sync to shared dev server
- move all DNS, VMs, dev accounts to BAMRU-managed userids

## 2018-03-15

Action:
- [x] installed postgres 9.1 on ting (see ansible role for PG config)
- [x] installed ruby 1.9.3 on ting (`ruby-install ruby-1.9.3-p551`)
- [x] add dotenv to load env values
- [x] regenerate mail_view gem
- [x] migrations work
- [x] backups load
- [x] server works
- [x] git push works
- [x] all specs pass

## 2018-03-30

- [x] create linode production server  (bamru.info)
- [x] create linode development server (dev.bamru.info)
- [x] create Gmail account  (tech@bamru.org) 
- [x] create GitHub account (tech@bamru.org)
- [x] configure Github (BAMRU-ORG) to accept pushes from tech@bamru.org
- [x] configure Github (BAMRU-NET) to accept pushes from tech@bamru.org
- [x] provision new production server  (user = deploy)
- [x] provision new development server (user = tech)

## 2018-03-31

- [x] add ruby 1.9 to dev and production machines
- [x] setup/config PG 9.1 on dev and producton
- [x] provision database users
- [x] setup Git keys to dev machine for user `bmrdev`
- [x] clone BAMRU-Org to dev.bamru.info
- [x] clone BAMRU-Private to dev.bamru.info
- [x] push from dev machine to BAMRU-Org
- [x] push from dev machine to BAMRU-Private
- [x] get migrations working

## 2018-04-01

NOTES: 1.9.3_net-ssh incompatible with Ubuntu 16.04
- instead use Ubuntu 14.04
- which only supports postgres 9.3...

- [x] copy backups to dev machine
- [x] load backup data
- [x] get server working
- [x] all specs pass
- [x] destroy and reprovision bamru.info and dev.bamru.info
- [x] create namecheap account for bmrdev
- [x] create linode account for bmrdev

## 2018-04-04

- [x] refactor utility scripts
- [x] test tech@bamru.org email address
- [x] create github account owned by `techbamru`
- [x] create linode account owned by `techbamru`
- [x] create namecheap account owned by `techbamru`
- [x] create nexmo account owned by `techbamru` (`tech@bamru.org`)

## 2018-04-11

- [x] get BAMRU CC for namecheap
- [x] get BAMRU CC for linode
- [x] get BAMRU CC for nexmo

## TBD

- [ ] transfer Linode VMs to the new BAMRU account
- [ ] transfer BAMRU.info to the new BAMRU registrar account
- [ ] configure new NEXMO numbers

- [ ] add a TMUX development console

- [ ] test net-ssh / SSH incompatibility

- [ ] get upstart working for bnet
- [ ] get upstart working for faye

- [ ] deploy to the new machine from ting
- [ ] deploy to the new machine from dev.bamru.info

- [ ] provision SSL certs for BAMRU.info

- [ ] test backups from BAMRU.info to dev machine
- [ ] test backups from BAMRU.net to BAMRU.info

- [ ] get BAMRU.org cron processes working on dev.bamru.info

- [ ] test paging on BAMRU.info
- [ ] redirect DNS bamru.net to bamru.info
- [ ] provision SSL certs for the new BAMRU.net

- [ ] transfer BAMRU.net to the new BAMRU registrar account

- [ ] create an operations guide (Craig/Kevin)
- [ ] train Craig and/or Kevin on system operations

- [ ] delete old BAMRU.net machine
- [ ] shutdown local backup scripts

