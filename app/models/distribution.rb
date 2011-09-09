class Distribution < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :member
  belongs_to :message
  has_many   :outbound_mails


  # ----- Callbacks -----



  # ----- Validations -----



  # ----- Scopes -----
  scope :sent,      where(:read => [true, false])
  scope :bounced,   where(:bounced => true)
  scope :read,      where(:read => true)

  scope :unread,    where(:read => false)

  # ----- Local Methods-----

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
