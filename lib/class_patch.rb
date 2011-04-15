require 'time'

class Time
  def to_label
    strftime "%b-%Y"
  end
end

class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
  def present?
    !blank?
  end
  def presence
    self if present?
  end
  def try(method, *args, &block)
    send(method, *args, &block)
  end
end

