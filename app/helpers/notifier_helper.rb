module NotifierHelper
  
  ROOT_URL = "http://bamru.net/"

  def rsvp_text(opts)
    return "" if opts['prompt'].blank?
    dist = opts['dist_id'] ? "#{ROOT_URL}unauth_rsvps/#{opts['unauth_rsvp_token']}" : "/home/preview"
    <<-EOF.gsub(/^      /, "")
      RSVP: #{opts['prompt']}
       YES: #{opts['yes_prompt']} (#{dist}?response=yes)
        NO: #{opts['no_prompt']} (#{dist}?response=no)
    EOF
  end

  def rsvp_html(opts)
    return "" if opts['prompt'].blank?
    dist = opts['dist_id'] ? "#{ROOT_URL}unauth_rsvps/#{opts['unauth_rsvp_token']}" : "/home/preview"
    <<-EOF.gsub(/^      /, "")
      RSVP: #{opts['prompt']}<p></p>
      <a href='#{dist}?response=yes' class='myButton greenButton'>YES #{opts['yes_prompt']}</a>
      <a href='#{dist}?response=no' class='myButton redButton'>NO #{opts['no_prompt']}</a>
      <p></p>
    EOF
  end

  def query_opts(opts = {})
    opts ||= {}
    opts['label']             ||= "member_abcd"
    opts['author_name']       ||= "TBD"
    opts['author_last_name']  ||= "TBD"
    opts['author_short_name'] ||= "TBD"
    opts['author_mobile']     ||= "NA"
    opts['author_email']      ||= "NA"
    opts['recipient_email']   ||= "<recipient list>"
    opts['text']              ||= ""
    opts['prompt']            ||= ""
    opts['no_prompt']         ||= ""
    opts['yes_prompt']        ||= ""
    opts['unauth_rsvp_token'] ||= "invalid"
    opts['rsvp_text']         = rsvp_text(opts)
    opts['rsvp_html']         = rsvp_html(opts)
    opts
  end

  def set_optz(message, address, label, dist)
    opts = query_opts
    opts['label']             = label
    opts['author_name']       = message.author.full_name
    opts['author_short_name'] = message.author.short_name
    opts['author_last_name']  = message.author.last_name
    opts['author_mobile']     = message.author.phones.mobile.first.try(:number) || "NA"
    opts['author_email']      = message.author.emails.first.try(:address) || "NA"
    opts['recipient_email']   = address
    opts['text']              = message.text
    opts['prompt']            = message.rsvp.try(:prompt)
    opts['yes_prompt']        = message.rsvp.try(:yes_prompt)
    opts['no_prompt']         = message.rsvp.try(:no_prompt)
    opts['dist_id']           = dist.id
    opts['unauth_rsvp_token'] = dist.unauth_rsvp_token
    opts['rsvp_text']         = rsvp_text(opts)
    opts['rsvp_html']         = rsvp_html(opts)
    opts
  end


end
