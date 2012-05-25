server 'fj1', :app, :web, :primary => true
server 'kana', :app, :web
server 'fils', :app, :web

desc "This is a production only task"
task :zzz do
  run "uptime"
end
