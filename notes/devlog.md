# BAMRU.net Development Log

Mission: setup so that BAMRU.net can be maintained indefinately as-is.

Goals:
- [ ] remove no-longer-needed dependencies
- [ ] upgrade production OS to 18.04
- [ ] upgrade database to modern version
- [ ] add docker containers for server and database
- [ ] shared dev environment in datacenter
- [ ] working backups to dev server
- [ ] add SSL

Approch:
- upgrade to modern tooling (ruby 2.5, rails 5.2, postgres 10.5)
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

# 2018-03-31

- [x] add ruby 1.9 to dev and production machines
- [x] setup/config PG 9.1 on dev and producton
- [x] provision database users
- [x] setup Git keys to dev machine for user `bmrdev`
- [x] clone BAMRU-Org to dev.bamru.info
- [x] clone BAMRU-Private to dev.bamru.info
- [x] push from dev machine to BAMRU-Org
- [x] push from dev machine to BAMRU-Private
- [x] get migrations working

# 2018-04-01

- [x] copy backups to dev machine
- [x] load backup data
- [x] get server working
- [x] all specs pass

# 2018-04-04

- [x] add tech@bamru.org email address
- [x] create nexmo account owned by `techbamru`
- [x] create linode account owned by `techbamru`
- [x] create namecheap account owned by `techbamru`
- [x] refactor utility scripts

# 2018-09-06

- [ ] upgrade ruby
- [ ] upgrade postgres
- [ ] upgrade rails

- [ ] get server to start
- [ ] get UI working
- [ ] get all tests passing

# TBD

- [ ] get rid of Procfile

- [ ] test net-ssh / SSH incompatibility

- [ ] get upstart working for bnet
- [ ] get upstart working for faye

- [ ] deploy to the new machine from ting
- [ ] deploy to the new machine from dev.bamru.info

- [ ] provision new working system on BAMRU.info

- [ ] test backups from BAMRU.info to dev machine
- [ ] test backups from BAMRU.net to BAMRU.info

- [ ] transfer Linode VMs to a new BAMRU account
- [ ] transfer BAMRU.info and BAMRU.net to a new BAMRU account

- [ ] get BAMRU.org cron processes working on dev.bamru.info

- [ ] test paging on BAMRU.info
- [ ] redirect DNS bamru.net to bamru.info

- [ ] delete old BAMRU.net machine
- [ ] shutdown local backup scripts

