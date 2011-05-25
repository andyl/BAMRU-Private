module MembersHelper
  def phone_checkbox(member)
    list = member.phones.pagable
    if list.blank? 
      "<td></td>"
    else
      "<td class=checkbox><input class='rck #{member.full_roles}' type='checkbox'></td>"
    end
  end

  def email_checkbox(member)
    list = member.emails.pagable
    if list.blank?
      "<td></td>"
    else
      "<td class=checkbox><input class='rck #{member.full_roles}' type='checkbox'></td>"
    end
  end
end
