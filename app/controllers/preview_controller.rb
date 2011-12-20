class PreviewController < ApplicationController

  BASE_DIR = "/tmp/preview_opts"

  require 'cgi'
  require 'json'

  before_filter :authenticate_member!

  # ----- controller helper methods -----
  def preview_query_opts
    hash_opts = {}
    tgtfile = "#{BASE_DIR}/#{current_member.id}.json"
    if File.exist? tgtfile
      json_opts  = CGI.unescape(File.read(tgtfile))
      hash_opts  = JSON.parse(json_opts)
    end
    hash_opts
  end

  # ----- controller methods -----
  def init_opts
    opts = params['opts']
    tgtfile = "#{BASE_DIR}/#{current_member.id}.json"
    system "mkdir -p #{BASE_DIR}"
    File.open(tgtfile, 'w') {|f| f.puts opts}
    redirect_to '/preview/mail_htm'
  end

  def mail_htm
    opts = preview_query_opts
    opts['recipient_email'] = 'member_address@gmail.com'
    @mail = ::Notifier.render_email_message(opts)
    bpart = @mail.parts.find {|x| x.content_type.include? "html"}
    @body = "#{bpart.body}"
    render :template => "preview/email", :layout => false
  end

  def mail_txt
    opts = preview_query_opts
    opts['recipient_email'] = 'member_address@gmail.com'
    @mail = ::Notifier.render_email_message(opts)
    bpart = @mail.parts.find {|x| x.content_type.include? "plain"}
    @body = "<pre id='message_body'>#{bpart.body}</pre>"
    render :template => "preview/email", :layout => false
  end

  def sms
    opts = preview_query_opts
    opts['recipient_email'] = 'member_address@gmail.com'
    @mail = ::Notifier.process_sms_message(opts)
    @body = "<pre id='message_body'>#{@mail.body}</pre>"
    render :template => "preview/email", :layout => false
  end

end
