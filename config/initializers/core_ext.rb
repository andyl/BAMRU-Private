require 'active_support/core_ext'

class Time

  def current_week
    (self.strftime("%U").to_i % 13) + 1
  end

  def current_quarter
    case beginning_of_quarter.month
      when 1  : 1
      when 4  : 2
      when 7  : 3
      when 10 : 4
    end
  end

end

class Numeric
  def quarters
    ActiveSupport::Duration.new(self * 91.days, [[:days, self * 91]])
  end
  alias :quarter :quarters
end

class Time
  def show
    self.strftime("%a %b %d %H:%M")
  end
end
