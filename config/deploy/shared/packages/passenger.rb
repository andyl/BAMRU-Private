Capistrano::Configuration.instance(:must_exist).load do

  after "deploy:update", "passenger:nginx_conf"

  namespace :passenger do

    desc "Export an passenger config file."
    task :nginx_conf, :role => :web do
      template "nginx_passenger.erb", "/etc/nginx/conf.d/#{app_name}.conf"
    end

  end

end
