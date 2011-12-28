class Message < ActiveRecord::Base

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

  def breakify(text)
    text_index = 0
    while text[text_index..-1].length > 70
      next_index = text[text_index..-1].index(' ') || text.length
      next_index = 1 if next_index == 0
      text.insert(text_index + 70, ' ') if next_index > 70
      text_index = next_index + text_index
    end
    text
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

  # ----- Create Outbound Mails -----

  def label4c
    rand((36**4)-1).to_s(36)
  end

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


  # ----- Class Methods

  def self.devices(array)
    array.reduce({}) do |a,v|
      a[v] = true
      a
    end
  end

  def self.distributions_params(hash)
    int1 = hash.keys.map {|k| k.split('_')}
    int2 = int1.reduce({}) do |a,v|
      a[v.first] = ((a[v.first] || []) << v.last).uniq
      a
    end
    int2.keys.reduce([]) do |a,v|
      a << {:member_id => v}.merge(devices(int2[v]))
      a
    end
  end

  def self.mobile_distributions_params(hash)
    int1 = hash.keys.map {|k| k.split('-').last}  #array of member id's
    int1.map do |v|
      {:member_id => v, :email => true, :phone => true}
    end
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

