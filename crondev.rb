# Use this file to easily define all of your cron jobs.
# This performs cron actions on the development machine.
# Not the production machine!
#
# to generate cronfile : `whenever -f crondev.rb --update-crontab`
# for help on whenever : `whenever -h`
# to see cron settings : `crontab -l`
#
# Learn more:
# - http://github.com/javan/whenever  | cron processor
# - http://en.wikipedia.org/wiki/Cron | cron instructions

set :output, '/tmp/cron_bnet.log'

every 1.day, at: '2:30 am' do
  script  'cron_backup.sh'
end

