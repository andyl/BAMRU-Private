class HistoryController < ApplicationController

  before_filter :authenticate_member!

  def show
    @distribution = Distribution.find(params['id'])
    @member       = @distribution.member
    @recipient    = @member
    @message      = @distribution.message
    @mails        = @distribution.all_mails
    if @distribution.member_id == current_member.id
      @distribution.mark_as_read(current_member, "Read via web")
    end
    @journals     = @distribution.journals
  end

  def update
    @member       = current_member
    @dist_id      = params['id'].to_i
    @distribution = Distribution.find(@dist_id)
    @distribution.mark_as_read(@member, "Marked as read")
    if newval = params['dist']['rsvp_answer']
      @distribution.set_rsvp(@member, newval)
    end
    render :nothing => true
  end

  def markall
    @member = current_member
    @member.distributions.unread.all.each do |d|
      d.mark_as_read(@member, "Marked as read")
    end
    render :nothing => true
  end

  def ignore
    puts "IGNORE #{params.inspect}"
    inb = InboundMail.find(params[:id])
    inb.update_attributes({:ignore_bounce => true})
    render :nothing => true
  end

  def disable
    puts "DISABLE #{params.inspect}"
    inb = InboundMail.find(params[:id])
    om = inb.outbound_mail
    om.phone.update_attributes({:pagable => "0"}) if om.phone
    om.email.update_attributes({:pagable => "0"}) if om.email
    render :nothing => true
  end

end
