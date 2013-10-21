require 'csv'

module Export
  class Members
    def self.all
      puts "Gathering Member data"
      memarr = Member.all.map do |mem|
        [
          mem.first_name,
          mem.last_name,
          mem.typ,
          mem.developer,
          mem.photos.first.try(:image).try(:url)
        ]
      end
      puts "Generating CSV output"
      CSV.open('/tmp/members.csv', 'w') do |csv|
        memarr.each do |mem|
          csv << mem
        end
      end
      puts "Copying Member Image Files"
      image_dir = "/tmp/system/images"
      system "rm -r #{image_dir}" if Dir.exist?(image_dir)
      system "mkdir -p #{image_dir}"
      dirs = Dir.glob("public/system/images/*/original")
      dirs.each do |path|
        base = path.split('/')[1..-2].join('/')
        tmp_base = image_dir + '/' + base
        system "mkdir -p #{tmp_base}"
        system "cp -r #{path} #{tmp_base}"
        print '.' ; $stdout.flush
      end
      puts "\nCopied #{dirs.length} files"
      "OK"
    end
  end
end
