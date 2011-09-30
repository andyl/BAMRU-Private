module MobileHelper

  def inbox_prefix(dist)
    c1 = dist.read ? "-" : "*"
    c2 = if dist.rsvp_answer.nil?
      "_"
    else
      dist.rsvp_answer[0..0].downcase
    end
    c2 = 'x' unless dist.message.rsvp
    c1
  end

  def inbox_rsvp(dist)
    return "" if dist.message.rsvp.blank?
    "(RSVP: #{dist.message.rsvp.prompt})"
  end

  def inbox_helper(dist)
    text = inbox_prefix(dist) + " ##{dist.message.id} #{dist.message.text} #{inbox_rsvp(dist)}"
    link_to text, "/mobile/messages/#{dist.message.id}"
  end

  def page_name
    return "BAMRU Mobile" unless defined?(@page_name)
    "#{@page_name}"
  end

  def response_helper(msg, dist)
    ans = dist.rsvp_answer || "NONE"
    prompt = ""
    prompt = msg.rsvp.yes_prompt if ans == "Yes"
    prompt = msg.rsvp.no_prompt  if ans == "No"
    "<b>#{ans.upcase} #{prompt}</b>"
  end

  def response_buttons(msg, dist)
    ans = dist.rsvp_answer || "NONE"
    yr = ""; nr = ""
    yr = "<a href='/mobile/messages/#{msg.id}?response=yes' data-role='button'>Change to: YES #{msg.rsvp.yes_prompt}</a>" unless ans=="Yes"
    nr = "<a href='/mobile/messages/#{msg.id}?response=no' data-role='button'>Change to: NO #{msg.rsvp.no_prompt}</a>" unless ans=="No"
    yr + nr
  end

  def display_phones(member)
    return "" if member.phones.blank?
    header  = '<div data-role="listview" data-inset="true" data-theme="c">'
    divider = "<li data-role='list-divider'>Phones</li>"
    display = member.phones.map do |phone|
      if @phone
        val1 = "<a href='tel:#{phone.number}'>#{phone.number} - #{phone.typ}</a>"
        val2 = phone.typ == "Mobile" ? "<a href='sms:#{phone.number}'></a>" : ""
        "<li>#{val1}#{val2}</li>"
      else
        "<li>#{phone.number} - #{phone.typ}</li>"
      end
    end.join
    "#{header}#{divider}#{display}</div>"
  end

  def display_emergency_contacts(member)
    return "" if member.emergency_contacts.blank?
    header  = '<div data-role="listview" data-inset="true" data-theme="c">'
    divider = "<li data-role='list-divider'>Emergency Phone Contacts</li>"
    display = member.emergency_contacts.map do |contact|
      phone_str = "#{contact.name} #{contact.number} (#{contact.typ})"
      if @phone
        val1 = "<a href='tel:#{contact.number}'>#{phone_str}</a>"
        val2 = contact.typ == "Mobile" ? "<a href='sms:#{contact.number}'></a>" : ""
        "<li>#{val1}#{val2}</li>"
      else
        "<li>#{phone_str}</li>"
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

  def display_other_info(member)
    return "" if member.other_infos.blank?
  end

  def display_ham_v9(member)
    ham = member.ham.blank? ? "" : "<b>Ham:</b> #{member.ham}<br/>"
    v9  = member.v9.blank? ?  "" : "<b>V9:</b> #{member.v9}<br/>"
    total = ham + v9
    total.blank? ? "" : total
  end

  def display_photos(member)
    return "" if member.photos.blank?
    member.photos.limit(3).map {|pic| image_tag(pic.image.url(:thumb))}.join + "<br/>"
  end

  def set_buttons(wth)
    <<-ERB
      <div data-role="controlgroup" data-type="horizontal" data-role="fieldcontain" style='text-align: center;'>
        <input type="checkbox" name="#{wth}_cktm" id="#{wth}_cktm" class="custom sbx b_TM" />
        <label for="#{wth}_cktm">TM</label>
        <input type="checkbox" name="#{wth}_ckfm" id="#{wth}_ckfm" class="custom sbx b_FM" />
        <label for="#{wth}_ckfm">FM</label>
        <input type="checkbox" name="#{wth}_cktx" id="#{wth}_cktx" class="custom sbx b_T" />
        <label for="#{wth}_cktx">T</label>
      </div>
    ERB
  end

  def clear_buttons
    <<-ERB
      <div data-role="controlgroup" data-type="horizontal" data-role="fieldcontain" style='margin-bottom: 0px; text-align: center;'>
        <a href="#" class="clear_all" data-role="button" data-inline='true'><del>All</del></a>
        <a href="#" class="clear_oot" data-role="button" data-inline='true'><del>OOT</del></a>
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
        <li><a href="#" id="select_link" data-role="button">Select<span id=select_count></span></a></li>
        <li><a href="#" id="send_link"  data-role="button">Send</a></li>
      </ul>
    </div>
    ERB
  end


  def rsvp_mobile_select
    first_opt = "<option id=blank_select value='' selected='selected'></option>\n"
    opts = first_opt + RsvpTemplate.order('position ASC').all.map do |i|
      "<option value='#{i.output_json}' data-prompt='#{i.output_json}'>#{i.prompt}</option>\n"
    end.join
    "<select id='rsvp_select' name='rsvp_select' style='margin-top: 0px; width:100%;'>\n" + opts + "</select>"
  end

  def blue_wrap(text)
    "<span style='background-color: lightblue; padding-left 3px; padding-right 3px;'>#{text}</span>"
  end

  def sent_read(msg, format = "short")
    sent_count = msg.distributions.count
    read_count = msg.distributions.read.count
    return blue_wrap("(Sent #{sent_count} / Read #{read_count})") if format == "long"
    blue_wrap("S#{sent_count} R#{read_count}")
  end

  def yes_no(msg, format = "short")
    yes_count = msg.distributions.rsvp_yes.count
    no_count  = msg.distributions.rsvp_no.count
    return blue_wrap("(Yes #{yes_count} / No #{no_count})") if format == "long"
    blue_wrap("Y#{yes_count} N#{no_count}")
  end

  def msg_created(msg)
    "##{msg.id} #{msg.created_at.strftime("%m-%d %H:%M")} from #{msg.author.try(:short_name)}"
  end

  def rsvp_prompt(msg)
    msg.rsvp ? "<br/>RSVP: #{msg.rsvp.prompt} #{yes_no(msg, 'long')}" : ""
  end

  def message_header(msg)
    rsvp = msg.rsvp ? "<br/>#{yes_no(msg)} #{msg.rsvp.prompt}" : ""
    <<-ERB.gsub('    ','')
      #{msg_created(msg)}
      <p class='ui-li-desc' style='margin-top: 3px;'>
      #{sent_read(msg)} #{msg.text}
      #{rsvp}
      </p>
    ERB
  end

end