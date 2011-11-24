class MessageParams

  def self.base_params
    author = Member.where(:user_name => "auto_pager").first
    {
            "ip_address" => "NA",
            "author_id"  => author.id
    }
  end

  def self.password_reset(member, address)
    dist = [{ "member_id" => member.id.to_s, "email" => true }]
    {
      "text"                     => "Password Reset: #{member.last_name} (#{address})",
      "format"                   => "password_reset",
      "distributions_attributes" => dist
    }.merge(base_params)
  end

  def self.do_shift_pending(member)
    dist = [{"member_id" => member.id.to_s, "email" => true}]
    {
      "text" => "Reminder: Your DO shift starts Tuesday 8:00am. (#{member.last_name})",
      "format" => "do_shift_pending",
      "distributions_attributes" => dist
    }.merge(base_params)
  end

  def self.do_shift_starting(member)
    txt  = "Attention: Your DO shift is starting. (#{member.last_name})"
    dist = [{"member_id" => member.id.to_s, "email" => true, "phone" => true}]
    {
      "text" => txt,
      "format" => "do_shift_starting",
      "distributions_attributes" => dist
    }.merge(base_params)
  end

  def self.cert_notice(cert, message)
    member = cert.member
    txt = "Notice: Your #{cert.typ} cert #{message}. (#{member.last_name})"
    dist = [{"member_id" => member.id.to_s, "email" => true}]
    {
      "text" => txt,
      "format" => "cert_notice",
      "distributions_attributes" => dist
    }.merge(base_params)
  end
  
end