class NexmoNumberPool

  def self.next(number)
    nums = NEXMO_SMS_NUMBERS.split(' ')
    clean_num = sanitize_number(number)
    return nums.first if clean_num.blank?
    return nums.first unless nums.include? clean_num
    return nums.first if nums.last == clean_num
    new_index = nums.index(clean_num)+1
    nums[new_index]
  end

  def self.sanitize_number(number)
    return "" if number.blank?
    clean_number = number.strip.gsub('-','').gsub(' ','')
    return "1" + clean_number if clean_number.length == 10
    clean_number
  end

end