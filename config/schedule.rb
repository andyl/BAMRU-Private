# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

job_type :nq, "cd :path && export RAILS_ENV=:environment && script/nq :task"

every 2.minutes do
  nq "rake ops:raketest"
end

every 30.minutes do
  nq "rake ops:email:import ONLY_ON=bamru.net"
end

every 1.day, :at => '0:05 am' do
  nq "rake tmp:clear"
end

every 1.day, :at => '23:55 pm' do
  nq "rake tmp:clear"
end

