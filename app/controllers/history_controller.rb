class HistoryController < ApplicationController

  before_filter :authenticate_member!

  def show
    @distribution = Distribution.find(params['id'])
    @member       = @distribution.member
    @recipient    = @member
    @message      = @distribution.message
    @mails        = @distribution.all_mails
    if @distribution.member_id == current_member.id
      x_hash = {
              :distribution_id => @distribution.id,
              :member_id       => current_member.id,
              :action          => "Read via web"
      }
      Journal.create(x_hash) if @distribution.read == false
      @distribution.read = true
      @distribution.save
    end
    @journals     = @distribution.journals
  end

  def update
    @member       = current_member
    @dist_id      = params['id'].to_i
    @distribution = Distribution.find(@dist_id)
    if @distribution.read == false && params['dist']['read'] == 'true'
      Journal.create(:member_id => @member.id, :distribution_id => @distribution.id, :action => "Marked as read")
    end
    if params['dist']['rsvp_answer']
      params['dist']['read'] = 'true'
      if @distribution.read == false
        Journal.create(:member_id => @member.id, :distribution_id => @distribution.id, :action => "Marked as read")
      end
      Journal.create(:member_id => @member.id, :distribution_id => @dist_id, :action => "Set RSVP to #{params['dist']['rsvp_answer']}")
    end
    @distribution.update_attributes!(params[:dist])
    render :nothing => true
  end

  def markall
    @member = current_member
    @member.distributions.unread.all.each do |d|
      d.read = true
      d.save
      Journal.create(:member_id => @member.id, :distribution_id => d.id, :action => "Marked as read")
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
