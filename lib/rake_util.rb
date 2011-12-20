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
    if ENV['SYSNAME'] == "ekel"
      "http://ekel:3000/"
    else
      "http://bamru.net/"
    end
  end

  # ----- Generates a CURL Stringjj

  def curl_get(path)
    "curl -s -S -u #{SYSTEM_USER}:#{SYSTEM_PASS} #{local_url}#{path}"
  end

end