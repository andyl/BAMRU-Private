require 'csv'

module Export
  class Certs
    def self.all
      puts "Gathering Cert data"
      cert_arr = Cert.all.map do |cert|
        [
          cert.member.first_name,
          cert.member.last_name,
          cert.typ,
          cert.expiration,
          cert.description,
          cert.comment,
          cert.link,
          cert.position,
          cert.cert.url
        ]
      end
      puts "Generating CSV output"
      CSV.open('/tmp/certs.csv', 'w') do |csv|
        cert_arr.each do |cert|
          csv << cert
        end
      end
      puts "Copying Cert Files"
      certs_dir = "/tmp/system/certs"
      system "rm -r #{certs_dir}" if Dir.exist?(certs_dir)
      system "mkdir -p #{certs_dir}"
      dirs = Dir.glob("public/system/certs/*/original") 
      dirs.each do |path|
        base = path.split('/')[1..-2].join('/')
        tmp_base = certs_dir + '/' + base
        system "mkdir -p #{tmp_base}"
        system "cp -r #{path} #{tmp_base}"
        print '.' ; $stdout.flush
      end
      puts "\nCopied #{dirs.length} files"
      "OK"
    end
  end
end
