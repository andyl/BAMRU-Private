# BAMRU.net Development Log

Mission: setup so that BAMRU.net can be maintained indefinately as-is.

Goals:
- [x] upgrade production OS to 16.04
- [ ] shared dev environment in datacenter
- [ ] working backups to dev server
- [ ] add SSL

Approch:
- exactly model the current tooling (ruby 1.9.3, postgres 9.1)
- move BAMRU.org calendar sync to shared dev server
- move all DNS, VMs, dev accounts to BAMRU-managed userids

# 2018-03-15

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

# 2018-03-30

- [x] create linode production server  (bamru.info)
- [x] create linode development server (dev.bamru.info)
- [x] create Gmail account  (bmrdev@gmail.com/CallOut) 
- [x] create GitHub account (bmrdev@gmail.com/CallOut)
- [x] configure Github (BAMRU-ORG) to accept pushes from bmrdev
- [x] configure Github (BAMRU-NET) to accept pushes from bmrdev
- [x] provision new production server  (user = deploy)
- [x] provision new development server (user = bmrdev)

# TBD

- [ ] add Git keys to dev machine for user `bmrdev`
- [ ] push from dev machine to BAMRU-Org
- [ ] push from dev machine to BAMRU-Private

- [ ] add dev console

- [ ] deploy to the new machine from home
- [ ] deploy to the new machine from dev.bamru.info

- [ ] provision SSL certs for BAMRU.info

- [ ] test backups from BAMRU.info to dev machine
- [ ] test backups from BAMRU.net to BAMRU.info

- [ ] transfer Linode VMs to a new BAMRU account
- [ ] transfer BAMRU.info and BAMRU.net to a new BAMRU account

- [ ] get BAMRU.org cron processes working on dev.bamru.info

- [ ] test paging on BAMRU.info
- [ ] add redirect from BAMRU.net to BAMRU.info

- [ ] delete old BAMRU.net machine
- [ ] shutdown local backup scripts

