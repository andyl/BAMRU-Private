Capistrano::Configuration.instance(:must_exist).load do

  after "deploy:update", "mediawiki:nginx_conf"

  namespace :mediawiki do

    desc "Export an mediawiki config file."
    task :nginx_conf, :role => :web do
      template "nginx_mediawiki.erb", "/etc/nginx/conf.d/#{app_name}.conf"
    end

  end

end
