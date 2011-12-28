require 'uri'

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

  # ----- Generates a CURL String

  def curl_get(path, data = "")
    data_string = data.empty? ? "" : "?data=#{URI.escape(data)}"
    %[curl -s -S -u #{SYSTEM_USER}:#{SYSTEM_PASS} "#{local_url}#{path}#{data_string}"]
  end

  def curl_post(path, data = "")
    data_payload = data.empty? ? "" : %[-d "data=#{URI.escape(data)}"]
    %[curl -s -S -X POST -u #{SYSTEM_USER}:#{SYSTEM_PASS} "#{local_url}#{path}" #{data_payload}]
  end

end