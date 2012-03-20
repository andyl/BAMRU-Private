class Message < ActiveRecord::Base

  has_ancestry

  include MessageExtension::Base
  extend  MessageExtension::Klass

  # ----- Associations -----

  belongs_to :author,         :class_name => 'Member'
  has_one    :rsvp,           :dependent  => :destroy
  has_many   :distributions,  :dependent  => :destroy
  has_many   :outbound_mails, :through    => :distributions
  has_many   :recipients,     :through    => :distributions, :source => :member

  accepts_nested_attributes_for :distributions, :allow_destroy => true

  # ----- Callbacks -----


  # ----- Validations -----


  # ----- Scopes -----


  # ----- Local Methods-----
  def has_open_bounce?
    dist_b = distributions.bounced
    return false if dist_b.blank?
    dist_b.any? {|dist| dist.has_open_bounce?}
  end

  def has_fixed_bounce?
    dist_b = distributions.bounced
    return false if dist_b.blank?
    dist_b.any? {|dist| dist.has_fixed_bounce?}
  end

  def text_with_rsvp
    text_with_spaces = breakify(text)
    return text_with_spaces unless rsvp
    "#{text_with_spaces} (RSVP: #{rsvp.prompt})"
  end

  def rsvp_stats
    return "NA" unless rsvp
    "Y:#{distributions.rsvp_yes.count} N:#{distributions.rsvp_no.count}"
  end

  # ----- Local Methods (Create Outbound Mails) -----

  def gen_label
    new_label = label4c
    new_label = label4c until OutboundMail.where(:label => new_label).empty?
    new_label
  end

  def create_one_outbound_mail(dist, hash)
    hash[:label] = gen_label
    hash[:distribution_id] = dist.id
    ! dist.outbound_mails.where(:address => hash[:address]).empty? || OutboundMail.create!(hash)
    if dist.message.rsvp
      dist.update_attributes({:rsvp => true})
    end
  end

  def create_all_outbound_mails
    self.distributions.each do |dist|
      member = dist.member
      if dist.phone?
        member.phones.pagable.each do |phone|
          create_one_outbound_mail(dist, {:phone_id => phone.id, :address => phone.sms_email})
        end
      end
      if dist.email?
        member.emails.pagable.each do |email|
          create_one_outbound_mail(dist, {:email_id => email.id, :address => email.address})
        end
      end
    end
  end

  # ----- Class Methods -----

  def self.generate(mesg, dist, rsvp = {})
    mesg[:distributions_attributes] = Message.distributions_params(dist)
    mesg[:format] = 'page'
    mesg_obj = Message.create(mesg)
    puts dist.inspect
    unless rsvp.blank?
      opts = JSON.parse(rsvp)
      opts[:message_id] = mesg_obj.id
      Rsvp.create(opts)
    end
    mesg_obj.create_all_outbound_mails
    mesg_obj
  end

end

# == Schema Information
#
# Table name: messages
#
#  id         :integer         not null, primary key
#  author_id  :integer
#  ip_address :string(255)
#  text       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  format     :string(255)
#

