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

cmd = "script/nq :task >> log/nq.log 2>&1"
job_type :nq, "cd :path && export RAILS_ENV=:environment && #{cmd}"

# ----- Automated eMail Reminders and Alerts -----

every 1.day,  :at => '10:10 pm' do
  nq "rake ops:email:generate:cert_expiration_reminders"
  nq "rake ops:email:send_pending"
end

every :sunday,  :at => '11:10 pm' do
  nq "rake ops:email:generate:do_shift_pending_reminder"
  nq "rake ops:email:send_pending"
end

every :tuesday, :at => '8:05 am' do
  nq "rake ops:set_do"
  sleep 30
  nq "rake tmp:clear"
  sleep 30
  nq "rake ops:email:generate:do_shift_started_reminder"
  sleep 30
  nq "rake ops:email:send_pending"
end

# ----- Retrieve incoming email from Google -----

every 30.minutes do
  nq "rake ops:email:import ONLY_ON=bamru.net"
end

# ----- Reset Page Cache -----

every 1.day, :at => '0:02 am' do
  nq "rake tmp:clear"
end

# ----- Backups -----

every 1.month, :at => "start of the month at 1:10 am" do
  nq "rake ops:backup:wiki_full"
end

every 1.week, :at => '2:10 am' do
  nq "rake ops:backup:wiki_data"
end

every 1.week, :at => '3:10 am' do
  nq "rake ops:backup:system"
end

every 1.day, :at => '4:10 am' do
  nq "rake ops:backup:db"
end

# ----- Remove Old Data -----

every :wednesday, :at => '11:10 pm' do
  nq "rake ops:log_cleanup"
  nq "rake ops:message_cleanup"
end

every :sunday, :at => '5:10 am' do
  nq "rake ops:log_cleanup"
  nq "rake ops:message_cleanup"
end
