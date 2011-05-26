module MembersHelper
  def phone_checkbox(member)
    list = member.phones.pagable
    if list.blank? 
      "<td></td>"
    else
      "<td class=checkbox><input class='rck #{member.full_roles}' name='distributions[#{member.id}_phone]' type='checkbox'></td>"
    end
  end

  def email_checkbox(member)
    list = member.emails.pagable
    if list.blank?
      "<td></td>"
    else
      "<td class=checkbox><input class='rck #{member.full_roles}' name='distributions[#{member.id}_email]' type='checkbox'></td>"
    end
  end
end
