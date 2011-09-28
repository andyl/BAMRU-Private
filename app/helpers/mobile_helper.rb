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

  def set_buttons(wth)
    <<-ERB
      <div data-role="controlgroup" data-type="horizontal" data-role="fieldcontain" style='text-align: center;'>
        <input type="checkbox" name="#{wth}_cktm" id="#{wth}_cktm" class="custom" />
        <label for="#{wth}_cktm">TM</label>
        <input type="checkbox" name="#{wth}_ckfm" id="#{wth}_ckfm" class="custom" />
        <label for="#{wth}_ckfm">FM</label>
        <input type="checkbox" name="#{wth}_cktx" id="#{wth}_cktx" class="custom" />
        <label for="#{wth}_cktx">T</label>
      </div>
    ERB
  end

  def clear_buttons
    <<-ERB
      <div data-role="controlgroup" data-type="horizontal" data-role="fieldcontain" style='margin-bottom: 0px; text-align: center;'>
        <a href="#" data-role="button" data-inline='true'><del>All</del></a>
        <a href="#" data-role="button" data-inline='true'><del>OOT</del></a>
      </div>
    ERB
  end

  def wide_layout
    <<-ERB
      <div id=wideLayout style='margin-bottom:15px;'>
        <fieldset class="ui-grid-a">
          <div class="ui-block-a">#{set_buttons("w")}</div>
          <div class="ui-block-b">#{clear_buttons}</div>
        </fieldset>
      </div>
    ERB
  end

  def narrow_layout
    "<div id=narrowLayout>#{set_buttons("n")}#{clear_buttons}</div>"
  end

  def select_layout
    "#{wide_layout}#{narrow_layout}"
  end

  def paging_nav
    <<-ERB
    <div data-role="navbar">
      <ul>
        <li><a href="#" id="select_link" data-role="button">Select</a></li>
        <li><a href="#" id="send_link"  data-role="button">Send</a></li>
      </ul>
    </div>
    ERB
  end


  def rsvp_mobile_select
    first_opt = "<option id=blank_select value='NA' selected='selected'></option>\n"
    opts = first_opt + RsvpTemplate.order('position ASC').all.map do |i|
      "<option value='#{i.name}' data-prompt='#{i.output_json}'>#{i.prompt}</option>\n"
    end.join
    "<select id=rsvp_select>\n" + opts + "</select>"
  end

end