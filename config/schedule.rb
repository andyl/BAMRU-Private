# Use this file to define cron jobs.
#
# More info on cron: http://en.wikipedia.org/wiki/Cron
# Learn more: http://github.com/javan/whenever

cmd = "script/nq :task >> log/nq.log 2>&1"
job_type :nq, "cd :path && export RAILS_ENV=:environment && #{cmd}"

# ----- Automated eMail Reminders and Alerts -----

every 1.day,  :at => '5:10 pm' do
  nq "rake ops:email:generate:cert_notices"
end
every 1.day,  :at => '5:15 pm' do
  nq "rake ops:email:pending:send"
end

every :thursday,  :at => '7:10 pm' do
  nq "rake ops:email:generate:do_shift_pending"
end
every :thursday, :at => '7.15 pm' do
  nq "rake ops:email:pending:send"
end

every :tuesday, :at => '7:10 am' do
  nq "rake ops:email:generate:do_shift_starting"
end
every :tuesday, :at => '7:15 am' do
  nq "rake ops:email:pending:send"
end

every :tuesday, :at => '8:02 am' do
  nq "rake tmp:clear"
end

every :tuesday, :at => '8:11 am' do
  nq "rake tmp:clear"
end

# ----- Broadcast the date to the Event Monitor channel -----
every 6.hours do
  nq "rake faye:datecast"
end

# ----- Retrieve incoming email from Google -----

every 30.minutes do
  nq "rake ops:email:import ONLY_ON=bamru.net"
end

# ----- Reset Page Cache -----

every 1.day, :at => '0:05 am' do
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
end
every :wednesday, :at => '11:40 pm' do
  nq "rake ops:message_cleanup"
end

every :sunday, :at => '5:10 am' do
  nq "rake ops:log_cleanup"
end
every :sunday, :at => '5:40 am' do
  nq "rake ops:message_cleanup"
end

every :sunday, :at => '5:50 am' do
  nq "rake ops:avail_op_cleanup"
end
