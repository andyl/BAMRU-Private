require 'rubygems'
require 'rspec/core/example'
require 'rspec/core/formatters/progress_formatter'
require 'colored'

class RSpec::Core::Example
  attr_reader :example_block
end

# Custom formatter for Rspec - intended for use with RubyMine
# Auto-displays the failed spec in RubyMine
#
# to use:
# rspec -r /path/to/rm_auto_display_formatter.rb -f progress -f RmAutoDisplayFormatter --fail-fast
#
# tested on: Ubuntu 12.04, RubyMine 4.5, Ruby 1.9.3, Rspec 2.11

class RmAutoDisplayFormatter < RSpec::Core::Formatters::ProgressFormatter

  RUBY_MINE_CMD = "/home/aleak/lcl/bin/rubymine/bin/rubymine.sh"

  def example_failed(example_obj)
    target_file = example_obj.example_block.to_s.split(/\@|\>/).last
    file, line = target_file.split(':')
    cmd = "#{RUBY_MINE_CMD} --line #{line} #{file} &"
    @output.puts "\n Failed Spec: #{target_file}".cyan
    @output.puts   "RubyMine Cmd: #{cmd}".cyan
    system cmd
  end

end
