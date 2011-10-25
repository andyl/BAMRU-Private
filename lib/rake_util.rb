module RakeUtil

  # ----- Utilities for generating unique message labels -----

  def label4c
    rand((36**4)-1).to_s(36)
  end

  def gen_label
    new_label = label4c
    new_label = label4c until OutboundMail.where(:label => new_label).empty?
    puts "New Label is #{new_label}"
    new_label
  end

  # ----- Generates a URL to the local machine -----

  def local_url
    include Rails.application.routes.url_helpers
    default_url_options[:host] = (Rails.env == "development") ? "ekel" : "bamru.net"
    default_url_options[:port] = "3000" if Rails.env == "development"
    root_url
  end

  # ----- Generates a CURL Stringjj

  def curl_get(path)
    "curl -s -S -u #{SYSTEM_USER}:#{SYSTEM_PASS} #{local_url}#{path}"
  end

end