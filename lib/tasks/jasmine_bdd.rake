desc "Run the Jasmine Server"
task :jas do
  system "xterm_title '<jasmine> #{File.basename(`pwd`).chomp}@#{ENV['SYSNAME']}:8888'"
  Rake::Task['jasmine'].invoke
end

desc "Run the Guard Server"
task :guard do
  system "xterm_title '<guard> #{File.basename(`pwd`).chomp}@#{ENV['SYSNAME']}'"
  system "bundle exec guard"
end