module InboxHelper

  def mark_as_read(distribution, member)
    return "" if distribution.read?
    return "" unless current_member.admin? || member == current_member 
    "(<a href='#' class=markready id='markread_#{distribution.id}'>mark as read</a>)"
  end

end
