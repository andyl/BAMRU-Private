class Notifier < ActionMailer::Base
  extend NotifierHelper

  def platform_url
    return "http://ekel:3000/" if Rails.env.development?
    return "http://bamru.net/" if Rails.env.production?
    ""
  end

  # ----- test -----

  def test(opts = {})
    address = opts[:author_email] ? 'test@what.com' : opts[:author_email]
    mail(
            :to       => address,
            :from     => "#{GMAIL_USER}@gmail.com",
            :reply_to => "#{GMAIL_USER}@gmail.com",
            :subject  => "Test @ #{Time.now}"
    )
  end

  # ----- password reset -----

  def password_reset_email(opts = {})
    Time.zone     = "Pacific Time (US & Canada)"
    @platform_url = platform_url
    @url          = @platform_url + "password/reset"
    @opts         = opts
    @address      = opts['recipient_email']
    @short_label  = opts['label'].split('_').last
    @member       = Email.find_by_address(@address).member
    @member.reset_forgot_password_token
    @expire       = @member.forgot_password_expires_at.strftime("%H:%M")
    mail(
            :to       => @address,
            :from     => "BAMRU <#{GMAIL_USER}@gmail.com>",
            :reply_to => "#{GMAIL_USER}@gmail.com",
            :subject  => "BAMRU.net Password Reset (#{opts['label']})"
    )
  end

  # ----- page -----

  def page_email(opts = {})
    Time.zone     = "Pacific Time (US & Canada)"
    @opts         = Notifier.query_opts(opts)
    @short_label  = @opts['label'].split('_').last
    @platform_url = platform_url
    mail(
            :to       => @opts['recipient_email'],
            :from     => "BAMRU (#{@opts['author_short_name']}) <#{GMAIL_USER}@gmail.com>",
            :reply_to => "#{GMAIL_USER}@gmail.com",
            :subject  => "BAMRU Page [#{@opts['label']}]"
    )
  end

  def page_phone(opts = {})
    Time.zone = "Pacific Time (US & Canada)"
    @opts = Notifier.query_opts(opts)
    mail(
            :to        => @opts['recipient_email'],
            :from      => "BAMRU (#{@opts['author_short_name']}) <#{GMAIL_USER}@gmail.com>",
            :reply_to  => "#{GMAIL_USER}@gmail.com",
            :subject   => "BAMRU [#{@opts['label']}]"
    )
  end

  # ----- do_shift_pending -----

  def do_shift_pending_email(opts = {})
    Time.zone     = "Pacific Time (US & Canada)"
    @opts         = Notifier.query_opts(opts)
    @short_label  = @opts['label'].split('_').last
    @platform_url = platform_url
    mail(
            :to       => @opts['recipient_email'],
            :from     => "BAMRU (#{@opts['author_short_name']}) <#{GMAIL_USER}@gmail.com>",
            :reply_to => "#{GMAIL_USER}@gmail.com",
            :subject  => "BAMRU DO shift - Reminder [#{@opts['label']}]"
    )
  end

  # ----- do_shift_started -----

  def do_shift_starting_email(opts = {})
    Time.zone     = "Pacific Time (US & Canada)"
    @opts         = Notifier.query_opts(opts)
    @short_label  = @opts['label'].split('_').last
    @platform_url = platform_url
    mail(
            :to       => @opts['recipient_email'],
            :from     => "BAMRU (#{@opts['author_short_name']}) <#{GMAIL_USER}@gmail.com>",
            :reply_to => "#{GMAIL_USER}@gmail.com",
            :subject  => "BAMRU DO shift - starting! [#{@opts['label']}]"
    )
  end

  def do_shift_starting_phone(opts = {})
    Time.zone = "Pacific Time (US & Canada)"
    @opts = Notifier.query_opts(opts)
    mail(
            :to       => @opts['recipient_email'],
            :from     => "BAMRU (#{@opts['author_short_name']}) <#{GMAIL_USER}@gmail.com>",
            :reply_to => "#{GMAIL_USER}@gmail.com",
            :subject  => "BAMRU [#{@opts['label']}]"
    )
  end

    # ----- cert_notice -----

    def cert_notice_email(opts = {})
      Time.zone     = "Pacific Time (US & Canada)"
      @opts         = Notifier.query_opts(opts)
      @short_label  = @opts['label'].split('_').last
      @platform_url = platform_url
      mail(
              :to       => @opts['recipient_email'],
              :from     => "BAMRU (#{@opts['author_short_name']}) <#{GMAIL_USER}@gmail.com>",
              :reply_to => "#{GMAIL_USER}@gmail.com",
              :subject  => "BAMRU Cert Notice [#{@opts['label']}]"
      )
    end

    # ----- Inbound Email Issue Notifications -----

    def inbound_exception_notice(opts = {})
      Time.zone     = "Pacific Time (US & Canada)"
      @opts = opts
      mail(
          :to       => 'andy@r210.com',
          :from     => "BAMRU.net <#{GMAIL_USER}@gmail.com>",
          :reply_to => "#{GMAIL_USER}@gmail.com",
          :subject  => "[BAMRU.net] Inbound Exception (#{@opts[:from]} / #{Time.now.strftime("%b %d - %H:%M:%S")})"
      )
    end

    def inbound_unmatched_notice(opts = {})
      Time.zone     = "Pacific Time (US & Canada)"
      @opts = opts
      mail(
          :to       => 'andy@r210.com',
          :from     => "BAMRU.net <#{GMAIL_USER}@gmail.com>",
          :reply_to => "#{GMAIL_USER}@gmail.com",
          :subject  => "[BAMRU.net] Inbound Unmatched (#{@opts[:from]} / #{Time.now.strftime("%b %d - %H:%M:%S")})"
      )
    end

    def inbound_uncertain_match_notice(opts = {})
      Time.zone     = "Pacific Time (US & Canada)"
      @opts = opts
      mail(
          :to       => 'andy@r210.com',
          :from     => "BAMRU.net <#{GMAIL_USER}@gmail.com>",
          :reply_to => "#{GMAIL_USER}@gmail.com",
          :subject  => "[BAMRU.net] Inbound Uncertain Match (#{@opts[:from]} / #{Time.now.strftime("%b %d - %H:%M:%S")})"
      )
    end

    def inbound_unrecognized_rsvp_notice(opts = {})
      Time.zone     = "Pacific Time (US & Canada)"
      @opts = opts
      mail(
          :to       => 'andy@r210.com',
          :from     => "BAMRU.net <#{GMAIL_USER}@gmail.com>",
          :reply_to => "#{GMAIL_USER}@gmail.com",
          :subject  => "[BAMRU.net] Unrecognized RSVP (#{@opts[:from]} / #{Time.now.strftime("%b %d - %H:%M:%S")})"
      )
    end

    # ----- Event Alerts -----

  def event_alert(opts = {})
    Time.zone     = "Pacific Time (US & Canada)"
    @opts = opts
    mail(
      :to       => opts[:send_to],
      :from     => "BAMRU.net <#{GMAIL_USER}@gmail.com>",
      :reply_to => "#{GMAIL_USER}@gmail.com",
      :subject  => "[BAMRU.net] CHANGE NOTIFICATION (#{Time.now.strftime("%b %d - %H:%M:%S")})"
    )
  end

end