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
      when "all"    then current_period.participants.mem_ids
      when "invite" then Member.pluck(:id)
      when "leave"  then current_period.participants.has_not_left.mem_ids
      when "return" then current_period.participants.is_en_route.mem_ids
        else []
    end
  end

  def default_message
    case @format
      when "all"    then "re:#{current_event.title}/OP#{current_period.position} - "
      when "invite" then "Immediate Callout - #{current_event.title}/OP#{current_period.position}"
      when "leave"  then "re:#{current_event.title}/OP#{current_period.position} - your transit status"
      when "return" then "re:#{current_event.title}/OP#{current_period.position} - your transit status"
        else ""
    end
  end

  def default_rsvp
    ""
  end

  def should_check?(member)
    selected_members.include? member.id
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
    return unless %w(all leave return invite).include? params["format"]

    @period = params["period"].to_i
    @format = params["format"]
  end

end