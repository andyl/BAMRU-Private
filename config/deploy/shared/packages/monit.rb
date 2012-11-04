# These tasks are to config monit alerts.
# Assumptions:
# - monit is installed by puppet at /etc/monit
# - there are local envireonment variables for monit-alert.conf:
#   MONIT_GMAIL_USER
#   MONIT_GMAIL_PASS

Capistrano::Configuration.instance(:must_exist).load do

  before "deploy:update", "monit:alert"

  namespace :monit do

    desc "Export an passenger config file."
    task :alert do
      if ENV['GMAIL_MONIT_SMTP_USER'].nil?
        puts "ERROR: GMAIL_MONIT_SMTP_USER is not defined"
      else
        template "monit_alert.erb", "/etc/monit/conf.d/monit_alert.conf"
      end
    end

  end

end
