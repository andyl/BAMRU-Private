class Message < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :author,         :class_name => 'Member'
  has_many   :distributions
  has_many   :recipients,     :through => :distributions, :source => :member
  has_many   :outbound_mails, :through => :distributions
  has_many   :rsvp_responses
  has_one    :rsvp

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
    return text unless rsvp
    "#{text} (RSVP: #{rsvp.prompt})"
  end

  def rsvp_stats
    return "NA" unless rsvp
    "Y:#{distributions.rsvp_yes.count} N:#{distributions.rsvp_no.count}"
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
#

