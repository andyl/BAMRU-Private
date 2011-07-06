#!/usr/bin/env ruby

require 'rubygems'
require 'faye'

class FayeChat
  module KbInput
    include EM::Protocols::LineText2
    def receive_line(msg)
      $fc_client.publish($fc_channel, "#{$fc_nick}: #{msg}")
    end
  end

  def self.print_msg(text) print text; STDOUT.flush; end

  def self.run(url, channel, nick)
    $fc_client  = Faye::Client.new(url)
    $fc_channel = channel
    $fc_nick    = nick

    trap(:INT) { EM.stop_event_loop }

    puts "Starting chat client, ^C to exit..."
    print_msg "#{$fc_nick}> "

    EM.run do
      $fc_client.subscribe($fc_channel) do |msg|
        print_msg("\n#{msg}\n#{$fc_nick}> ")
      end
      EM.open_keyboard(KbInput)
    end
  end
end

if File.basename($0) == File.basename(__FILE__)
  abort "Usage: #{$0} <url> <channel> <nick>" if ARGV.length != 3
  url, channel, nick = ARGV
  FayeChat.run(url, channel, nick)
end