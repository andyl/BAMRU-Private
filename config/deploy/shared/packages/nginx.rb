Capistrano::Configuration.instance(:must_exist).load do

  after "deploy:update", "nginx:export_conf"

  namespace :nginx do

    desc "Export an nginx config file."
    task :export_conf, :role => :web do
      template "nginx_passenger.erb", "/etc/nginx/conf.d/#{app_name}.conf"
    end

    %w[start stop status restart reload].each do |command|
      desc "#{command} nginx"
      task command, roles: :web do
        run "#{sudo} /etc/init.d/nginx #{command}"
      end
    end
  end

end
