class PageGenSvc

  attr_reader   :message, :members, :params
  attr_accessor :period, :format, :selected_members

  def initialize(message = nil, members = nil, params = nil)
    @message = message
    @members = members
    @params  = params
    @period = @format = nil
    process_params(@params)
  end

  def selected_members
    return [] if @period.nil?
    @selected_members ||= case @format
      when "info"      then current_period.participants.mem_ids
      when "invite"    then Member.pluck(:id)
      when "broadcast" then Member.pluck(:id)
      when "leave"     then current_period.participants.has_not_left.mem_ids
      when "return"    then current_period.participants.is_en_route.mem_ids
        else []
    end
  end

  def default_message
    case @format
      when "info"      then "re:#{current_event.title}/OP#{current_period.position} - "
      when "broadcast" then "re:#{current_event.title}/OP#{current_period.position} - "
      when "invite"    then "Immediate Callout - #{current_event.title}/OP#{current_period.position}"
      when "leave"     then "re:#{current_event.title}/OP#{current_period.position} - transit status"
      when "return"    then "re:#{current_event.title}/OP#{current_period.position} - transit status"
        else ""
    end
  end

  def should_check?(member)
    selected_members.include? member.id
  end

  def form_fields
    return "" unless @period && @format
    ""
    v1 = "<input type='hidden' value='#{@period}' name='message[period_id]'/>"
    v2 = "<input type='hidden' value='#{@format}' name='message[period_format]'/>"
    v1 + v2
  end

  def activated?
    @period && @format
  end

  def header_nav
    label, view = case @format
              when "info"      then ["Information Message", "none"]
              when "invite"    then ["Unit-Wide Invite", "none"]
              when "broadcast" then ["Unit-Wide Broadcast", "none"]
              when "leave"     then ["Departure Query", "transit"]
              when "return"    then ["Return Query", "transit"]
                else ["Page", "none"]
            end
    path = "/events/#{current_event.id}/roster?view=#{view}&period=#{current_period.id}"
    text = "#{current_event.title}/OP#{current_period.position}"
    xlink = "<a href='#{path}'>#{text}</a>"
    "#{label} for #{xlink}"
  end

  private
  
  def current_period
    @current_period ||= Period.find(@period)
  end
  
  def current_event
    @current_event ||= current_period.event
  end

  def process_params(params)
    return unless params && params["period"] && params["format"]
    return unless %w(info broadcast leave return invite).include? params["format"]

    @period = params["period"].to_i
    @format = params["format"]
  end

end

