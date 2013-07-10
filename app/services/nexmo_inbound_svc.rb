class NexmoInboundSvc

  #"msisdn"=>"16508230836"
  #"to"=>"16505643031"
  #"text"=>"Yes"

  def initialize(params)
    puts " START NEXMO PARAMS ".center(80, '*')
    puts params.inspect
    puts " END NEXMO PARAMS ".center(80, '*')
    @params = params
    @opts   = {}
    @opts[:to]   = params["to"]
    @opts[:from] = params["msisdn"]
    @opts[:body] = params["text"]
    @opts[:send_time] = Time.now.to_s
  end

  def load
    begin
      create_from_opts(@opts) unless @opts[:body].blank?
    rescue Exception
      puts "Inbound SMS Exception (from #{@opts[:from]})"
      Notifier.inbound_exception_notice(@opts).deliver
    end
  end

  # ----- Class Methods -----

  def create_from_opts(opts)
    valid_yes = %w(Yep Yea Y)
    valid_no  = %w(N Not Unavail Unavailable)
    opts[:bounced]  = false

    puts "POINT-A"

    # ----- get RSVP answer -----
    first_words = (opts[:body] || "").split(' ')[0..30].join(' ')
    match = first_words.match(/\b(yep|yea|yes|y|no|n|not|unavail|unavailable)\b/i)
    opts[:rsvp_answer] = match && match[0].capitalize
    opts[:rsvp_answer] = "Yes" if valid_yes.include? opts[:rsvp_answer]
    opts[:rsvp_answer] = "No"  if valid_no.include?  opts[:rsvp_answer]

    puts "POINT-B"

    # ----- find matching outbound_mail
    select_hash = {sms_service_number: opts[:to], sms_service_number: opts[:to]}
    outbound = OutboundMail.where(select_hash).recent.try(:first)

    puts "POINT-C"

    if outbound.nil?
      Notifier.inbound_unmatched_notice(opts).deliver
    else
      opts[:outbound_match]   = outbound.id
      outbound.read = true ; outbound.save
      member = outbound.distribution.member
      answer = opts[:rsvp_answer]

      unless outbound.distribution.message.rsvp.blank?
        if answer.blank?
          Notifier.inbound_unrecognized_rsvp_notice(opts).deliver
        end
      end

      label = "Marked as read (reply to #{opts[:label]})"
      outbound.distribution.mark_as_read(member, member, label)
      outbound.distribution.set_rsvp(member, member, answer) unless answer.nil?
    end

    puts "POINT-D"

    puts opts.inspect
    #{:to=>"16505643031", :from=>"16508230836", :body=>"Yes", :send_time=>2013-07-10 13:30:23 -0700, :bounced=>false, :rsvp_answer=>"Yes", :outbound_match=>37783, :outbound_mail_id=>37783}
    InboundMail.create!(opts)

    puts "POINT-E"

  end

end
