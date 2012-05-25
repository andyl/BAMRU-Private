require 'erb'

def render(from)
  erb = File.read(File.expand_path("../packages/templates/#{from}", File.dirname(__FILE__)))
  ERB.new(erb).result(binding)
end

def sudo_template(from, to)
  put render(from), "/tmp/_filetransfer"
  run "#{sudo} mv /tmp/_filetransfer #{to}"
end

def template(from, to)
  put render(from), to
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

def get_host
  capture("echo $CAPISTRANO:HOST$").strip
end

def remote_file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end
