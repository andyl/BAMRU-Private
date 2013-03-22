module EventReportsHelper

  def incident_name
    @event_report.event.title
  end

  def incident_name_with_period
    if @event_report.event.typ == "meeting"
      incident_name
    else
      "#{incident_name} - Period #{@event_report.period.position}"
    end
  end

  def adjusted_participants
    if @event_report.event.typ == "meeting"
      @event_report.period.participants.registered
    else
      @event_report.period.participants
    end
  end

  def num_participants
    adjusted_participants.count
  end

  def internal_aar_hours
    return "TBD" if adjusted_participants.length == 0
    adjusted_participants.map do |par|
      "#{par.member.last_name} (#{(par.sign_in_hours)} hours)"
    end.join(", ")
  end

  def participant_list
    adjusted_participants.map {|par| par.member.last_name}.join(', ')
  end

  def total_hours
    participant_minutes = adjusted_participants.map {|par| par.sign_in_minutes}
    return "TBD" if participant_minutes.include?("TBD")
    (participant_minutes.sum/60).round
  end

  def average_hours
    np = num_participants
    return "TBD" if np == 0
    th = total_hours
    return "TBD" if th == "TBD"
    (th / np.to_f).round(1)
  end

  def event_checkbox(type)
    @event_report.event.typ == type ? "X" : ""
  end

  def photo_gallery
    return "No Photos" if (ephotos = @event_report.event.event_photos).count == 0
    rows = ephotos.in_groups_of(5).map do |rows|
      cells = rows.map {|ep| ep.nil? ? "" : "<td><img src='#{ep.data_photo.image.url(:thumb)}'></td>"}.join
      "<tr>#{cells}</tr>"
    end.join
    "<table>#{rows}</table>"
  end

  def link_gallery
    return "No Links" if (elinks = @event_report.event.event_links).count == 0
    elinks.map do |el|
      "<a href='#{el.data_link.site_url}'>#{el.data_link.site_domain}</a> - #{el.data_link.caption}"
    end.join('<br/>')
  end

  def file_gallery
    return "No Files" if (efiles = @event_report.event.event_files).count == 0
    efiles.map do |el|
      "<a href='#{el.data_file.data.url}'>#{el.data_file.data_file_name}</a> - #{el.data_file.caption}"
    end.join('<br/>')
  end

  def event_label
    @event_report.event.typ.capitalize
  end
  
  def unit_hours(label)
    raw <<-HTML
    <td class='valueCell'>#{label.upcase}:</td>
    <td class='valueCell'></td>
    <td class='valueCell'>X</td>
    <td class='valueCell'></td>
    <td class='valueCell'>=</td>
    <td class='valueCell'></td>
    HTML
  end

  def multi_unit_hours
    labels = [
      ['dive/cliff',            'law liason'],
      ['exp. post 810',         'group liason'],
      ['exp. post 830',         'honor guard'],
      ['mounted sar',           'oes dist coord'],
      ['reserves',              'bomb squad'],
      ['scu (comms unit)',      'motorcycles'],
      ['smcsar',                'swat'],
      ['stars',                 'other']
    ]
    output = labels.map do |set|
      grp1 = unit_hours set.first
      grp2 = unit_hours set.last
      "<tr>#{grp1}#{grp2}</tr>"
    end.join
    raw output
  end


  def assignment(participant)
    return "" unless participant.ol
    case @event_report.event.typ
      when "training"  then "Training Leader"
      when "operation" then "Operation Leader"
      else "Leader"
    end
  end

  def time_in(participant)
    formatted_time(participant.signed_in_at)
  end

  def time_out(participant)
    formatted_time(participant.signed_out_at)
  end

  def formatted_time(time)
    return "TBD" unless time
    time.strftime("<nobr>%Y-%m-%d %H:%M</nobr>")
  end

  def event_date(format = "%B %d, %Y")
    event = @event_report.event
    fdate = event.finish
    start = event.start.strftime(format).upcase
    finish = fdate ? fdate.strftime(" TO #{format}").upcase : ""
    finish = "" if finish == " TO #{start}"
    start + finish
  end

  def date_prepared
    @event_report.updated_at.strftime("%Y-%m-%d")
  end

  def time_prepared
    @event_report.updated_at.strftime("%H:%M")
  end

  def participant_row(participant, idx)
    output = <<-HTML
      <tr>
        <td class='valueCell'>#{idx + 1}.</td>
        <td class='valueCell'>#{participant.member.full_name}</td>
        <td class='valueCell'>BAMRU</td>
        <td class='valueCell'>#{time_in(participant)}</td>
        <td class='valueCell'>#{time_out(participant)}</td>
        <td class='valueCell'>#{assignment(participant)}</td>
      </tr>
    HTML
    output
  end

  def participant_rows
    participant_list = adjusted_participants
    return if participant_list.empty?
    rows = participant_list.each_with_index.map do |participant, idx|
      participant_row(participant, idx)
    end
    output = rows.join
    raw output
  end



end
