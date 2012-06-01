Capistrano::Configuration.instance(:must_exist).load do

  namespace :depxt do

    #after :deploy, :update_gems, :setup_shared_cache, :setup_primary, :setup_backup
    #after "deploy:symlink", :reset_cron, :link_shared
    #after :nginx_conf, :restart_nginx

    desc "Reset Cron"
    task :reset_cron do
      #run "cd #{release_path} && bundle exec whenever --update-crontab #{application}"
    end

    desc "Setup shared cache."
    task :setup_shared_cache do
      cache_dir = "#{shared_path}/cache"
      vendor_dir = "#{release_path}/vendor"
      run "mkdir -p #{cache_dir} #{vendor_dir}"
      run "ln -s #{cache_dir} #{vendor_dir}/cache"
      run "cd #{release_path}; RAILS_ENV=production rake assets:precompile"
    end

    def remote_file_exists?(full_path)
      'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
    end

  end

end
