class Distribution < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :member
  belongs_to :message
  has_many   :outbound_mails, :dependent => :destroy
  has_many   :journals,       :dependent => :destroy


  # ----- Callbacks -----

  after_initialize :set_unauth_rsvp_token
  before_save :set_read_time


  # ----- Validations -----


  # ----- Scopes -----
  scope :sent,      -> { where(:read => [true, false]) }
  scope :bounced,   -> { where(:bounced => true)       }
  scope :read,      -> { where(:read => true)          }
  scope :unread,    -> { where(:read => false)         }

  scope :response_less_than,    lambda {|seconds| where('response_seconds < ?', seconds)}
  scope :response_greater_than, lambda {|seconds| where('response_seconds > ?', seconds)}

  scope :rsvp_yes,     -> { where(:rsvp_answer => "Yes") }
  scope :rsvp_no,      -> { where(:rsvp_answer => "No")  }
  scope :rsvp_pending, -> { where(:rsvp_answer => nil)   }

  # ----- Local Methods-----
  def has_open_bounce?
    bounced_om = outbound_mails.bounced.all
    return false if bounced_om.blank?
    bounced_om.any? { |om| om.has_open_bounce? }
  end

  def has_fixed_bounce?
    bounced_om = outbound_mails.bounced.all
    return false if bounced_om.blank?
    bounced_om.any? { |om| om.has_fixed_bounce? }
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

  # For this distribution and each linked distribution:
  # - mark the distribution as read
  # - update the RSVP answer
  # - generate a Journal entry
  #
  # @param admin_member [Member] Member who updates the record
  # @param target_member [Member] Target member
  # @param new_rsvp_value [String] 'Yes' or 'No'
  def set_rsvp(admin_member, target_member, new_rsvp_value)
    return unless self.rsvp?
    answer = cleanup_rsvp_value(new_rsvp_value)
    target_list(target_member).each do |dist|
      next if dist.rsvp_answer == answer
      dist.mark_as_read(admin_member, target_member, "Marked as read")
      dist.update_attributes rsvp_answer: answer
      Journal.add_entry(dist.id, admin_member, "Set RSVP to #{answer}")
      perform_event_action(target_member, dist.message, answer)
    end
  end

  # support RSVP actions
  def perform_event_action(member, message, answer)
    return if answer != "Yes"
    return unless message.period_id && message.period_format
    period = Period.find(message.period_id)
    return unless period
    case message.period_format
      when "invite" then period.add_participant(member)
      when "leave"  then period.set_departure_time(member)
      when "return" then period.set_return_time(member)
    end
  end

  # For this distribution and each linked distribution:
  # - mark the distribution as read
  # - generate a Journal entry
  #
  # @param admin_member [Member] Member who updates the record
  # @param target_member [Member] Target member
  # @param comment [String] Comment text
  def mark_as_read(admin_member, target_member, comment = "Marked as read")
    return if self.read?
    target_list(target_member).each do |dist|
      next if dist.read?
      Journal.add_entry(dist.id, admin_member, comment)
      dist.update_attributes(read:true)
    end
  end

  private

  def target_list(member)
    if link_id = self.message.linked_rsvp_id
      msg_list = Message.where(:linked_rsvp_id => link_id).all
      msg_list.reduce([]) do |a, msg|
        a = a + msg.distributions.where(:member_id => member.id).all
        a
      end
    else
      [self]
    end
  end

  def set_read_time
    return unless self.read_at.blank?
    if self.read == true
      self.read_at = Time.now
      self.response_seconds = (self.read_at - self.message.created_at).to_i
    end
  end

  def set_unauth_rsvp_token
    if self.unauth_rsvp_expires_at.blank?
      self.unauth_rsvp_token = rand(36 ** 8).to_s(36)
      self.unauth_rsvp_expires_at = Time.now + 1.week
    end
  end

  def cleanup_rsvp_value(new_value)
    answer = new_value.capitalize
    raise 'Invalid RSVP Response' unless %q(Yes No).include? answer
    answer
  end

end

# == Schema Information
#
# Table name: distributions
#
#  id                     :integer         not null, primary key
#  message_id             :integer
#  member_id              :integer
#  email                  :boolean         default(FALSE)
#  phone                  :boolean         default(FALSE)
#  read                   :boolean         default(FALSE)
#  bounced                :boolean         default(FALSE)
#  read_at                :datetime
#  response_seconds       :integer
#  rsvp                   :boolean         default(FALSE)
#  rsvp_answer            :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  unauth_rsvp_token      :string(255)
#  unauth_rsvp_expires_at :datetime
#

