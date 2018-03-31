# BAMRU.net Development Log

Goals:
- [ ] maintainable/deployable system
- [ ] upgrade production OS to 16.04
- [ ] confirm backup operation
- [ ] add SSL

Approch:
- exactly model the current tooling (ruby 1.9.3, postgres 9.1)
- setup so that the system can be maintained indefinately as-is
- create a shared dev-server in the datacenter
- if there is a follow-on version, build using new tech

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

# TBD

- [ ] provision linode production server  (user = deploy)
- [ ] provision linode development server (user = bamdev)

- [ ] create dev user (bamdev@github.com/CallOut) for GH push
- [ ] configure Github to accept pushes from bamdev

- [ ] add dev console
- [ ] deploy to the new machine from home
- [ ] deploy to the new machine from shared-dev

- [ ] provision SSL certs for BAMRU.info

- [ ] test backups from BAMRU.info to dev machine

- [ ] transfer Linode VMs to a BAMRU account
- [ ] transfer BAMRU.info and BAMRU.net to a BAMRU account

- [ ] delete old BAMRU.net machine

