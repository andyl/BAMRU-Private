module RegistryHelper

  def guest_icon(guest)
    photo = guest.photo_icon
    return "" if photo.empty?
    "<img style='height:23px;width:30px;display:block;margin:0;padding:0;' src='#{photo}'/>"
  end

  def show_label(member)
    "#{mem_typ_label(member)} Registry<br/><b>#{member.full_name}</b>"
  end

  def registry_link(member)
    "<a href='/registry/#{mem_typ_page(member)}'>#{mem_typ_label(member)} Registry</a>"
  end

  def registry_edit(member)
    typ = member.is_guest ? "guests" : "members"
    "<a href='/#{typ}/#{member.id}/edit' target='_blank'>Edit</a>"
  end

  def render_fields(member, coll)
    coll.map do |row|
      chk = row[0].downcase == member.typ.downcase ? "checked='checked'" : ""
     <<-EOF
        <label>
          <input #{chk} name="member[typ]" type="radio" value="#{row[0]}">
          #{row[1]}
        </label><br/>
      EOF
    end.join
  end

  def guest_typ_fields(member)
    coll = [
      ["T", "T - Trainee"],
      ["G", "G - Guest"],
      ["GA", "GA - Guest Alum"],
      ["GN", "GN - Guest NoContact"]
    ]
    render_fields(member, coll)
  end

  def member_typ_fields(member)
    coll = [
      ["TM", "TM - Technical Member"],
      ["FM", "FM - Field Member"],
      ["T", "T - Trainee"],
      ["R", "R - Reserve"],
      ["S", "S - Support"],
      ["A", "A - Associate"],
      ["MA", "MA - Member Alum"],
      ["MN", "MN - Member NoContact"]
    ]
    render_fields(member, coll)
  end

  def member_typ_form(member)
    <<-EOF
    <form action="/registry/update/#{member.id}" method="post">
    <input type='hidden' name='authenticity_token' value='#{form_authenticity_token}'/>
    #{member.is_guest ? guest_typ_fields(member) : member_typ_fields(member)}<br/>
    <input type='button' name='cancel' value="Cancel" id='cancelButton' />
    <input type="submit" value="Submit">
    </form>
    EOF
  end

  def mem_typ_label(member)
    case member.typ
      when "TM", "FM", "T", "R", "S", "A"
        "Member"
      when "G" then  "Guest"
      when "GA" then "Guest Alum"
      when "GN" then "Guest NoContact"
      when "MA" then "Member Alum"
      when "MN" then "Member NoContact"
      else
        "UNK"
    end
  end

  def mem_typ_page(member)
    case mem_typ_label(member)
      when "Member" then "members"
      when "Guest Alum" then "guest_alums"
      when "Guest NoContact" then "guest_ncs"
      when "Member Alum" then "member_alums"
      when "Member NoContact" then "member_ncs"
    end
  end

  # ----- this is for registry#alerts -----

  def role_list
    %w(UL XO OO SEC TO RO TRS REG WEB)
  end

  def alert_header_row
    cells = role_list.map {|role| alert_header_cell(role)}.join
    "<tr><th>Event</th>#{cells}</tr>"
  end

  def alert_header_cell(role)
    "<th width=80 align='center'>#{role}<br/><span style='font-size: 7pt;'>#{srole(role)}</span></th>"
  end

  def event_list
    %w(CreateGuest UpdateGuestRole CreateMember UpdateMemberRole) +
    %w(CreateEvent UpdateEvent DeleteEvent) +
    %w(CreateCert  UpdateCert  DeleteCert)
  end

  def subscription_cell(event, role)
    notifier = AlertSubscription.for(event, role)
    notifier ? "X" : "-"
  end

  def alert_body_rows
    event_list.map do |event|
      cells = role_list.map do |role|
        "<td class='alertCell' align=center id='#{role}-#{event}'>#{subscription_cell(event, role)}</td>"
      end.join
      "<tr><td>#{event}</td>#{cells}</tr>"
    end.join
  end

end

