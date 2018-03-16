# 2018-03-15

Goals:
- [ ] maintainable/deployable system
- [ ] upgrade production OS to 16.04
- [ ] confirm backup operation
- [ ] add documentation
- [ ] add SSL

Approch:
- exactly model the current tooling (ruby 1.9.3, postgres 9.1)
- setup so that the system can be maintained indefinately as-is
- create a shared dev-server in the datacenter
- if there is a follow-on version, build using new tech

Action:
- [x] installed postgres 9.1 on ting (see ansible role for postgres configuration)
- [x] installed ruby 1.9.3 on ting (`ruby-install ruby-1.9.3-p551`)
- [x] migrations work
- [x] backups load
- [x] server works
- [x] git push works
- [x] all specs pass

# TBD

- [ ] create linode development server
- [ ] create linode production server
- [ ] add dev console
- [ ] deploy to the new machine from home
- [ ] deploy to the new machine from shared-dev
- [ ] provision SSL certs for BAMRU.net 
- [ ] add configuration for SSL to production

