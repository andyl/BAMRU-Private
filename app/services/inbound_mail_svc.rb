class InboundMailSvc

  def initialize(tmp_dir = "/tmp/inbound_mails")
    @tmp_dir = tmp_dir
  end

  def load_inbound
    dir = Rails.root.to_s + @tmp_dir
    count = 0
    file_list = Dir.glob(dir + '/*').select { |f| File.file?(f) }
    file_list.each do |file|
      count += 1
      opts   = YAML.load(File.read(file))
      begin
        create_from_opts(opts)
      rescue Exception
        puts "Inbound Mail Exception (from #{opts[:from]})"
        Notifier.inbound_exception_notice(opts).deliver
        exception_dir = "#{File.dirname(file)}/exception"
        system "mkdir -p #{exception_dir} ; cp #{file} #{exception_dir}"
      end
      system "rm #{file}"
    end
    count
  end

  # ----- Class Methods -----

  def match_code(input)
    input.match(/\[[a-z\- ]*\_([0-9a-z][0-9a-z][0-9a-z][0-9a-z])\]/) ||
        input.match(/\.([0-9a-z][0-9a-z][0-9a-z][0-9a-z])/)
  end

  def create_from_mail(mail)
    opts = {}
    opts[:subject]   = mail.subject
    opts[:from]      = mail.from.join(' ')
    opts[:to]        = mail.to.join(' ')
    #opts[:uid]       = mail.try(:uid)
    opts[:body]      = mail.body.to_s.lstrip
    opts[:send_time] = mail.date.to_s
    create_from_opts(opts)
  end

  def create_from_opts(opts)
    valid_yes = %w(Yep Yea Y)
    valid_no  = %w(N Not Unavail Unavailable)
    opts[:bounced]  = true if opts[:from].match(/mailer-daemon/i)
    first_words = opts[:body].split(' ')[0..30].join(' ')
    match = first_words.match(/\b(yep|yea|yes|y|no|n|not|unavail|unavailable)\b/i)
    opts[:rsvp_answer] = match && match[0].capitalize
    opts[:rsvp_answer] = "Yes" if valid_yes.include? opts[:rsvp_answer]
    opts[:rsvp_answer] = "No"  if valid_no.include? opts[:rsvp_answer]
    outbound = nil
    if match = self.match_code("#{opts[:subject]} #{opts[:body]}")
      opts[:label] = match[1]
      outbound = OutboundMail.where(:label => opts[:label]).first
    end
    if outbound.nil?
      select_hash = {:address => opts[:from].downcase}
      outbound = OutboundMail.where(select_hash).order('created_at ASC').last
      opts[:outbound_match] = outbound.id unless outbound.nil?
      Notifier.inbound_uncertain_match_notice(opts).deliver unless outbound.nil?
    end
    if outbound.nil?
      Notifier.inbound_unmatched_notice(opts).deliver
    else
      opts[:outbound_mail_id] = outbound.id
      if opts[:bounced]
        outbound.distribution.bounced = true
        outbound.distribution.save
        outbound.bounced = true
        outbound.save
      else
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
    end
    InboundMail.create!(opts)
  end

end

