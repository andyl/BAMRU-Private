require 'rake'

module VtUtil
  class RakeTasks

      desc "Create an nginx conf file"
      task :nginx_conf do


      @nginx_conf = <<-EOF

      server {
        listen 80;
        server_name bamru-public.#{`hostname`.chomp} bamru.info bamru.net;
        charset utf-8;
        root #{ENV['PWD'].chomp}/public;
        passenger_enabled on;
        rack_env development;
      }

      EOF


        conf_dir = "/home/aleak/a/_conf"
        conf_file = "#{conf_dir}/BAMRU-Public.conf"
        system "mkdir -p #{conf_dir}"
        puts @nginx_conf
        puts "wrote nginx_conf to #{conf_file}\n\n"
        File.open(conf_file, 'w') do |f|
          f.puts @nginx_conf
        end
      end

      desc "Reset/Restart nginx"
      task :nginx_reset => :nginx_conf do
        system "ng reload"
      end
    end

end

