require 'time'

class Time
  def to_label
    strftime "%b-%Y"
  end
end
