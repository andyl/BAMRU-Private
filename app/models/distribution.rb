class Distribution < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :member
  belongs_to :message
  has_many   :outbound_mails
  has_many   :journals


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

  scope :rsvp_yes,  where(:rsvp_answer => "Yes")
  scope :rsvp_no,   where(:rsvp_answer => "No")

  # ----- Local Methods-----

  def rsvp_display_answer(txt_case = :downcase)
    return "NA" unless message.rsvp
    rsvp_answer.try(txt_case) || "NONE"
  end

  def rsvp_display_link
    val = rsvp_display_answer
    return val if val == "NA"
    "<a href='/rsvps/#{id}'>#{val}</a>"
  end

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

# == Schema Information
#
# Table name: distributions
#
#  id               :integer         not null, primary key
#  message_id       :integer
#  member_id        :integer
#  email            :boolean         default(FALSE)
#  phone            :boolean         default(FALSE)
#  read             :boolean         default(FALSE)
#  bounced          :boolean         default(FALSE)
#  read_at          :datetime
#  response_seconds :integer
#  created_at       :datetime
#  updated_at       :datetime
#

