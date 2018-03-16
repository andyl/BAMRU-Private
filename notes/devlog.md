# 2018-03-15

Goals:
- [ ] maintainable/deployable system
- [ ] add SSL
- [ ] upgrade production OS to 16.04
- [ ] confirm backup operation

Decision: 
- exactly model the tooling for the current app
- do not upgrade the current tooling (ruby 1.9.3, postgres 9.1)
- just get it to the point that it can be maintained indefinately
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

- [ ] add dev console
- [ ] create new machine
- [ ] provision a new machine
- [ ] deploy to the new machine
- [ ] add configuration for SSL

