ENV["QC_DATABASE_URL"] = "postgres://bnet:#{POSTGRES_PASS}@localhost/bnet_#{Rails.env.chomp}"
ENV["QC_LISTENING_WORKER"]="true"