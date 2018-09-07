# Capistrano::Configuration.instance(:must_exist).load do
#
#   set :scm,        :git
#   set :appdir,     application
#   set :deploy_via, :remote_cache
#   set :use_sudo,   false
#
#   set(:deploy_to) { "/home/#{user}/run/#{application}" }
#
#   default_run_options[:pty]   = true
#   ssh_options[:forward_agent] = true
#
#   after "deploy", "deploy:cleanup" # keep only the last 5 releases
#
#   # ---------------------------------------------------------------------------------
#   # see http://henriksjokvist.net/archive/2012/2/deploying-with-rbenv-and-capistrano/
#   require "bundler/capistrano"
#   set :bundle_flags, "--deployment --quiet --binstubs"
#   #set :bundle_flags, "--deployment --quiet --binstubs --shebang ruby-local-exec"
#
#   # also see http://ryan.mcgeary.org/2011/02/09/vendor-everything-still-applies/
#
#
#   # ---------------------------------------------------------------------------------
#   # get sudo password at the beginning of the run
#   task :sudo_setup, :roles => :app do
#     run "#{sudo} date"
#   end
#   before "deploy", "sudo_setup"
#
# end
