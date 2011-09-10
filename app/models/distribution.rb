class Distribution < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :member
  belongs_to :message
  has_many   :outbound_mails


  # ----- Callbacks -----

  before_save :set_read_time



  # ----- Validations -----



  # ----- Scopes -----
  scope :sent,      where(:read => [true, false])
  scope :bounced,   where(:bounced => true)
  scope :read,      where(:read => true)

  scope :unread,    where(:read => false)

  def self.response_less_than(seconds)
    where('response_seconds < ?', seconds)
  end

  # ----- Local Methods-----

  def set_read_time
    return unless self.read_at.blank?
    if self.read == true
      self.read_at = Time.now
      self.response_seconds = (self.read_at - self.message.created_at).to_i
    end
  end

  def status
    base  = self.read? ? "Read" : "Sent"
    extra = self.bounced? ? "/Bounced" : ""
    base + extra
  end

  def all_mails
    outbound_mails.map do |outb|
      {
        :outbound => outb,
        :inbound  => outb.inbound_mails.all
      }
    end
  end



end
