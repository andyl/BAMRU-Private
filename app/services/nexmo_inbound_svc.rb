class NexmoInboundSvc

  def initialize(params)
    @params = params
    @opts   = {}
    @opts[:to]   = params["to"]
    @opts[:from] = params["msisdn"]
    @opts[:body] = params["text"]
    @opts[:send_time] = Time.now
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
    debugger

    # ----- get RSVP answer -----
    first_words = (opts[:body] || "").split(' ')[0..30].join(' ')
    match = first_words.match(/\b(yep|yea|yes|y|no|n|not|unavail|unavailable)\b/i)
    opts[:rsvp_answer] = match && match[0].capitalize
    opts[:rsvp_answer] = "Yes" if valid_yes.include? opts[:rsvp_answer]
    opts[:rsvp_answer] = "No"  if valid_no.include?  opts[:rsvp_answer]

    puts "POINT-B"
    debugger

    # ----- find matching outbound_mail
    select_hash = {sms_service_number: opts[:to], sms_service_number: opts[:to]}
    outbound = OutboundMail.where(select_hash).recent.try(:first)

    puts "POINT-C"
    debugger

    if outbound.nil?
      Notifier.inbound_unmatched_notice(opts).deliver
    else
      opts[:outbound_match]   = outbound.id
      opts[:outbound_mail_id] = outbound.id
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
    debugger

    InboundMail.create!(opts)
  end

end
