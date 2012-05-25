Capistrano::Configuration.instance(:must_exist).load do

  # see https://github.com/stjernstrom/capistrano_colors

  require 'capistrano_colors'

  capistrano_color_matchers = [
    { :match => /command finished/,       :color => :hide,      :prio => 10 },
    { :match => /servers:/,               :color => :hide,      :prio => 10 },
    { :match => /^transaction: commit$/,  :color => :magenta,   :prio => 10 },
    { :match => /executing command/,      :color => :cyan,      :prio => 10, :attribute => :dim },
    { :match => /git/,                    :color => :white,     :prio => 20, :attribute => :reverse },
  ]

  colorize( capistrano_color_matchers )

end
