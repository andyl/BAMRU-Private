class QcShow

  def self.pending_count
    puts OutboundMail.pending.count
  end

  def self.member_count
    puts Member.count
  end

  def self.render(input)
    result = eval(input)
    puts result
  end

end