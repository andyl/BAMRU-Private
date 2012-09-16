module ApplicationHelper



def parent_repage_link(message)
   return "" unless message.parent
   label = "repage of ##{message.parent.id}"
   " [#{link_to(label, message.parent)}]"
 end

   def child_repage_link(message)
     return "" if message.children.blank?
     child_links = message.children.map do |msg|
       link_to("##{msg.id}", msg)
     end.join(", ")
     <<-EOF
         <tr>
           <td align=right><b>Follow-on Repages:</b></td>
           <td>
             #{child_links}
           </td>
         </tr>
     EOF
   end

  def rsvp_display_answer(dist, txt_case = :downcase)
    return "NA" unless dist.message.rsvp
    dist.rsvp_answer.try(txt_case) || "PENDING"
  end

  def pending_member_list(message)
    message.distributions.rsvp_pending.map {|d| d.member.last_name}.sort
  end

  def rsvp_display_link(dist)
    val = rsvp_display_answer(dist)
    return val if val == "NA"
    "<a class='rsvp_link' id='rsvp_link_#{dist.member.id}' data-msgid='#{dist.message.id}' data-rsvpid='#{dist.id}' data-name='#{dist.member.full_name}' href='#'>#{val}</a>"
  end

  def sprite_tag(klass, options = {})
    image_tag('s.gif', {:class => klass, :alt => klass}.merge(options))
  end

  def qr_tag(label, size = 8)
    file = "#{label.hash.abs}.png"
    loc = "/public/qrcodes"
    dir = Rails.root.to_s + loc
    puts dir
    uri = '/' + loc.split('/').last + '/' + file
    path = dir + '/' + file
    puts path
    unless File.exist?(path)
      system "mkdir -p #{dir}"
      Pngqr.encode label, :file => path, :border => 5, :size => size
    end
    "<img src='#{uri}'></img>"
  end

  def broadcast(channel, &block)
    message = {:channel => channel, :data => capture(&block)}
    uri = URI.parse("#{FAYE_SERVER}/faye")
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

  def checkbox(clas)
    %Q(<div style='float:right; margin-right: 10px;'><a href='#' onclick='$(".#{clas}").hide()'>X</a></div>)
  end

  def app_notice
    notice_value = notice
    string = "<p></p><div class='notice'>#{checkbox('notice')}<div>#{notice_value}</div></div>"
    notice_value.blank? ? "<p></p>" : string
  end

  def app_alert
    alert_value = alert
    alert_value.blank? ? "<p/>" : "<p class='alert'>#{alert_value}</p>"
  end

  def sign_out_link
    "<a href='/logout'>log out</a>"
  end

  def sign_up_or_in_link
    sign_in_link = "<a href='/members/sign_in'>sign in</a>"
    sign_up_link = "<a href='/members/sign_up'>sign up</a>"
    sign_in_link + ' | ' + sign_up_link
  end

  def sign_up_link
    link_to_unless_current("log in", '/login')
  end

  def inbox_count
    current_member.distributions.unread.count
  end

  def inbox_string
    count = inbox_count
    count == 0 ? "" : " (<span id=inbox_count>#{count}</span>)"
  end

  #def signed_in_header_nav
  #  roster = link_to_unless_current("Roster", members_path)
  #  log    = link_to_unless_current("Log",    messages_path)
  #  events = link_to_unless_current("Events", events_path)
  #  photos = link_to_unless_current("Photos", unit_photos_path)
  #  certs  = link_to_unless_current("Certs",  unit_certs_path)
  #  avail  = link_to_unless_current("Availability", unit_avail_ops_path)
  #  duty   = link_to_unless_current("DO", do_assignments_path)
  #  report = link_to_unless_current("Reports", '/reports')
  #  inbox  = link_to_unless_current(raw("Inbox#{inbox_string}"), member_inbox_index_path(current_member))
  #  opts   = [roster, log, events, photos, certs, avail, duty, report, inbox]
  #  opts.join(' | ')
  #end

  def signed_in_header_nav
    roster = link_to_unless_current("Roster", members_path)
    log    = link_to_unless_current("Log",    messages_path)
    events = link_to_unless_current("Events", events_path) do
      raw "<span id='event_link'>Events</span>"
    end
    photos = link_to_unless_current("Photos", unit_photos_path)
    certs  = link_to_unless_current("Certs",  unit_certs_path)
    avail  = link_to_unless_current("Availability", unit_avail_ops_path)
    duty   = link_to_unless_current("DO", do_assignments_path)
    report = link_to_unless_current("Reports", '/reports')
    inbox  = link_to_unless_current(raw("Inbox#{inbox_string}"), member_inbox_index_path(current_member))
    opts   = [roster, log, events, photos, certs, avail, duty, report, inbox]
    opts.join(' | ')
  end

  def favicon_file
    ENV['RAILS_ENV'] == "development" ? "/favicon_d1.ico" : "/favicon_p1.ico"
  end

  def header_nav
    if member_signed_in?
      signed_in_header_nav
    else
      ""
    end
  end

  def user_nav
    if member_signed_in?
      "welcome <b>#{current_member.first_name}</b> | #{sign_out_link}"
    else
      sign_up_link
    end
  end

  # ----- Misc Helpers -----
  def next_quarter(hash)
    lh = hash.clone
    if lh[:quarter] == 4
      lh[:year] += 1
      lh[:quarter] = 1
    else
      lh[:quarter] += 1
    end
    lh.delete(:week); lh.delete(:org_id)
    lh
  end

  def prev_quarter(hash)
    lh = hash.clone
    if lh[:quarter] == 1
      lh[:year] -= 1
      lh[:quarter] = 4
    else
      lh[:quarter] -= 1
    end
    lh.delete(:week); lh.delete(:org_id)
    lh
  end

  def link_prev(hash)
    link_to "<", do_assignments_path(prev_quarter(hash))
  end

  def link_next(hash)
    link_to ">", do_assignments_path(next_quarter(hash))
  end

  def link_current_quarter
    link_to "Current Quarter", do_assignments_path
  end

  def avail_dos_link_prev(hash)
    link_to "<", member_avail_dos_path(prev_quarter(hash))
  end

  def avail_dos_link_next(hash)
    link_to ">", member_avail_dos_path(next_quarter(hash))
  end

  def this_quarter_number
    Time.now.current_quarter
  end

  def next_quarter_number
    current_quarter = Time.now.current_quarter
    current_quarter == 4 ? 1 : current_quarter + 1
  end

  def avail_dos_link_for_member(member, quarter)
    hash = {:member_id => member.id}.merge(quarter)
    link_to member.last_name, member_avail_dos_path(hash), :class => 'memlink'
  end

  def avail_dos_link_next_quarter(message)
    hash = {:member_id => current_member.id, :quarter => Time.now.current_quarter, :year => Time.now.year}
    link_to message, member_avail_dos_path(next_quarter(hash))
  end

  def avail_dos_link_current_quarter(hash)
    link_to "Current Quarter", member_avail_dos_path(hash[:member_id])
  end

  def edit_link_prev(hash)
    link_to "<", edit_do_assignment_path(prev_quarter(hash))
  end

  def edit_link_next(hash)
    link_to ">", edit_do_assignment_path(next_quarter(hash))
  end

  def edit_link_current_quarter
    link_to "Current Quarter", edit_do_assignment_path
  end

  def plan_link_prev(hash)
    link_to "<", do_planner_path(prev_quarter(hash))
  end

  def plan_link_next(hash)
    link_to ">", do_planner_path(next_quarter(hash))
  end

  def plan_link_current_quarter
    link_to "Current Quarter", do_planner_path
  end

  def get_status(member, quarter, week)
    label = AvailDo.where(quarter).where(:member_id => member.id).where(:week => week).first
    return "" if label.blank?
    text = label.typ[0].capitalize
    text = '-' if text == "U"
    ftext = text == "A" ? "<b>#{text}</b>" : text
    comment = label.comment.blank? ? "" : "*"
    ftext + comment
  end
  
  def cellid(opts)
    "#{opts[:year]}-#{opts[:quarter]}-#{opts[:week]}-#{opts[:member].id}"
  end

  def selecthelper(opts)
    doa = DoAssignment.where(opts.slice(:year, :quarter, :week)).first
    return "" if doa.blank?
    return "" if doa.primary_id != opts[:member].id
    " green"
  end

  def comment_helper(opts)
    new_opts = opts.slice(:year, :quarter, :week).merge(member_id: opts[:member].id)
    avail = AvailDo.where(new_opts).first
    return "" if avail.blank?
    return "" if avail.comment.blank?
    "data-comments='#{avail.comment}'"
  end

  def display_member_row(member, quarter)
    memlink = avail_dos_link_for_member(member, quarter)
    part1 = "<tr class='memrow'><td id='mem#{member.id}' class='memlabel'><nobr><b class='memtag'>#{memlink}</b></nobr></td>"
    part2 = 13.times.map do |week|
      opts = quarter.merge({:member => member, :week => week+1})
      "<td id='#{cellid(opts)}' #{comment_helper(opts)} class='status#{selecthelper(opts)}'>#{get_status(member, quarter, week+1)}</td>"
    end.join
    part3 = "</tr>"
    part1 + part2 + part3
  end

  def display_date_range(quarter, week)
    "data-weekid='#{quarter[:year]}-#{quarter[:quarter]}-#{week}' " +
    "data-week='#{start_day(quarter, week)} - #{end_day(quarter, week)}'"
  end

  def start_day(quarter, week)
    start_time(quarter, week).strftime("%b #{start_time(quarter, week).day.ordinalize}")
  end

  def end_day(quarter, week)
    end_time(quarter, week).strftime("%b #{end_time(quarter, week).day.ordinalize}")
  end

  def start_time(quarter, week)
    day = Time.parse("Jan #{quarter[:year]}") + (quarter[:quarter]-1).quarters + (week-1).weeks + 8.hours
    adj_factor = case day.wday
      when 0 then 2
      when 1 then 1
      when 2 then 0
      when 3 then 6
      when 4 then 5
      when 5 then 4
      when 6 then 3
    end
    day + adj_factor.days
  end

  def end_time(quarter, week)
    start_time(quarter, week) + 1.week - 1.minute
  end

  def day_label(offset = 0)
    (Time.now + offset.days).strftime("%b %e")
  end

  def day_helper(member, offset = 0)
    day = Time.now + offset.days
    if member.avail_ops.busy_on?(day)
      "<td align=center style='background-color: pink;'>No</td>"
    else
      "<td></td>"
    end
  end

  def return_date_helper(member, offset)
    day = Time.now + offset.days
    return_date = member.avail_ops.return_date(day)
    return_date.nil? ? "" : (return_date + 1.day).strftime("%y-%m-%d")
  end

  def do_assignment_display_name_footer(assignment)
    return "" if assignment.nil?
    return assignment.name if assignment.primary.blank?
    if assignment.backup.blank?
      mem = assignment.primary
      link_to(mem.full_name, member_path(mem))
    else
      back = assignment.backup
      bstr = link_to(back.full_name, member_path(back))
      lstr = link_to('backup', do_assignments_path)
      "#{bstr} (#{lstr})"
    end
  end

  def do_assignment_display_name(assignment)
    return "" if assignment.nil?
    return assignment.name if assignment.primary.blank?
    if assignment.backup.blank?
      mem = assignment.primary
      link_to(mem.full_name, member_path(mem))
    else
      prim = assignment.primary
      back = assignment.backup
      bstr = link_to(back.full_name, member_path(back))
      pstr = link_to(prim.full_name, member_path(prim))
      "#{bstr} (backup for #{pstr})"
    end
  end

  # ----- Debug Helpers -----

  def params_debug_text
    "<b>#{params["controller"]}##{params["action"]}</b> (params: #{params.inspect})"
  end

  def request_env_debug_text
    "<b>Request.env:</b><br/>#{request.env["HTTP_COOKIE"].inspect}"
  end

  def debug_footer_text
    params_debug_text
  end

end