class ReminderParams

  def self.base_params
    author = Member.where(:user_name => "auto_pager").first
    {
            "ip_address" => "NA",
            "author_id"  => author.id
    }
  end

  def self.do_shift_pending(member)
    dist = [{"member_id" => member.id.to_s, "email" => true}]
    {
      "text" => "Your DO shift starts Tuesday 8:00am. DO instructions are on the wiki.",
      "distributions_attributes" => dist
    }.merge(base_params)
  end

  def self.do_shift_started(member)
    txt  = "Your DO shift has started.  Update the status line and send a page with your contact info."
    dist = [{"member_id" => member.id.to_s, "email" => true, "phone" => true}]
    {
      "text" => txt,
      "distributions_attributes" => dist
    }.merge(base_params)
  end
  
end