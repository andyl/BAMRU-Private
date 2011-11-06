namespace :pg do
  desc "Package all PhoneGap html and assets"
  task :build do
    system "rm -rf gap gap.zip public/assets; mkdir -p gap"
    system "rake assets:precompile:nondigest RAILS_ENV=production RAILS_GROUP=assets"
    html = `curl http://localhost:3000 2> /dev/null`
    File.open("gap/index.html", 'w') do |f|
      f.puts html.
                     gsub("/assets","assets").
                     gsub(/application-.+\.css/, "application.css").
                     gsub(/application-.+\.js/, "application.js").
                     gsub("</title>", "</title>\n <script src='phonegap.js'></script>")
    end
    system "mv public/assets gap"
    system "mv gap/assets/config.xml gap"
    system "mv gap/assets/ding.wav gap"
    system "mv gap/assets/icon.png gap"
    system "cd gap/assets; rm -f *z jquery*js rails*"
    system "zip -r gap.zip gap"

  end

  desc "Remove compiled assets"
  task :clean do
    system "rm -rf gap gap.zip"
    puts "OK"
  end

  desc "Upload / Rebuild the current app"
  task :load do
    usr_pwd = File.read("pgb_user.txt").chomp
    system "curl -u #{usr_pwd} -X PUT -F file=@gap.zip https://build.phonegap.com/api/v1/apps/44952"
    puts " "
  end

  desc "View the QR Code"
  task :qr do
    system "gnome-open https://build.phonegap.com/apps/44952"
  end

end