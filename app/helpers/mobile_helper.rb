module MobileHelper
  def page_name
    return "BAMRU Mobile" unless defined?(@page_name)
    "#{@page_name}"
  end

  def display_all(member)
  end

  def display_phones(member)
    return "" if member.phones.blank?
    header  = '<div data-role="listview" data-inset="true" data-theme="c">'
    divider = "<li data-role='list-divider'>Phones</li>"
    display = member.phones.map do |phone|
      if @phone
        "<li><a href='tel:#{phone.number}'>#{phone.number}</a></li>"
      else
        "<li>#{phone.number}</li>"
      end
    end.join
    "#{header}#{divider}#{display}</div>"
  end

  def display_addresses(member)
    return "" if member.addresses.blank?
  end

  def display_emails(member)
    return "" if member.emails.blank?
    header  = '<div data-role="listview" data-inset="true" data-theme="c">'
    divider = "<li data-role='list-divider'>eMails</li>"
    display = member.emails.map do |email|
      "<li><a href='mailto:#{email.address}'>#{email.address}</a></li>"
    end.join
    "#{header}#{divider}#{display}</div>"
  end

  def display_emergency_contacts(member)
    return "" if member.emergency_contacts.blank?
  end

  def display_other_info(member)
    return "" if member.other_infos.blank?
  end

  def display_ham_v9(member)
    ham = member.ham.blank? ? "" : "<b>Ham:</b> #{member.ham}<br/>"
    v9  = member.v9.blank? ?  "" : "<b>V9:</b> #{member.v9}<br/>"
    total = ham + v9
    total.blank? ? "" : total + "<p></p>"
  end

  def display_photos(member)
    return "" if member.photos.blank?
    tags = member.photos.map {|pic| image_tag(pic.image.url(:thumb))}.join
    "<b>Photos:</b><br/>" + tags
  end

end