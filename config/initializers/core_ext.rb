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
