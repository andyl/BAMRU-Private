# Use this file to define cron jobs.
#
# More info on cron: http://en.wikipedia.org/wiki/Cron
# Learn more: http://github.com/javan/whenever

cmd = "script/nq :task >> log/crontask.log 2>&1"
job_type :nq, "cd :path && export RAILS_ENV=:renv && #{cmd}"

# ----- Automated eMail Reminders and Alerts -----

every 1.day,  :at => '5:10 pm' do
  nq "rake ops:email:generate:cert_notices"
end

every :thursday,  :at => '7:10 pm' do
  nq "rake ops:email:generate:do_shift_pending"
end

every :tuesday, :at => '7:10 am' do
  nq "rake ops:email:generate:do_shift_starting"
end

every :tuesday, :at => '8:02 am' do
  nq "rake tmp:clear"
end

every :tuesday, :at => '8:11 am' do
  nq "rake tmp:clear"
end

# ----- Broadcast the date to the Event Monitor channel -----
every 2.hours do
  nq "rake faye:datecast"
end

# ----- Retrieve incoming email from Google -----

every 60.minutes do
  nq "rake ops:email:import"
end

# ----- Reset Page Cache -----

every 1.day, :at => '0:05 am' do
  nq "rake tmp:clear"
end

# ----- Backups -----

every 1.week, :at => '3:10 am' do
  nq "rake ops:backup:system"
end

every 1.day, :at => '4:10 am' do
  nq "rake ops:backup:db"
end

# ----- Remove Old Data -----

every :wednesday, :at => '11:10 pm' do
  nq "rake ops:log_cleanup"
end
every :wednesday, :at => '11:40 pm' do
  nq "rake ops:message_cleanup"
end
every :sunday, :at => '5:10 am' do
  nq "rake ops:browser_profile_cleanup"
end
every :sunday, :at => '5:20 am' do
  nq "rake ops:log_cleanup"
end
every :sunday, :at => '5:40 am' do
  nq "rake ops:message_cleanup"
end

every :sunday, :at => '5:50 am' do
  nq "rake ops:avail_op_cleanup"
end
