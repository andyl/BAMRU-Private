class Period < ActiveRecord::Base

  # ----- Associations -----

  belongs_to   :event
  has_many     :participants,  :dependent => :destroy
  has_many     :event_reports, :dependent => :destroy
  has_many     :messages
  acts_as_list :scope => :position


  # ----- Callbacks -----

  after_create   :create_smso_aar_event_report
  before_destroy :remove_all_message_references


  # ----- Validations -----



  # ----- Scopes -----



  # ----- Local Methods-----

  # ----- support RSVP actions

  def add_participant(member)
    return unless self.participants.by_mem_id(member.id).blank?
    self.participants.create(member_id: member.id)
  end

  def set_departure_time(member)
    return unless participant = self.participants.by_mem_id(member.id).first
    return if participant.en_route_at
    participant.update_attributes en_route_at: Time.now
  end

  def set_return_time(member)
    return unless participant = self.participants.by_mem_id(member.id).first
    return if participant.return_home_at
    participant.update_attributes return_home_at: Time.now
  end

  # ----- reporting

  def create_smso_aar_event_report
    return if %w(social).include? self.event.typ
    if self.event_reports.smso_aars.all.empty?
      title = self.event.typ == "meeting" ? "Meeting AAR" : "Period #{self.position} AAR"
      opts = {typ: "smso_aar", event_id: self.event.id, title: title}
      opts[:unit_leader] = "John Chang"
      opts[:signed_by]   = "Eszter Tompos"
      opts[:description] = self.event.description
      self.event_reports << EventReport.create(opts)
    end
  end

  def remove_all_message_references
    Message.where(period_id: self.id).each do |message|
      message.update_attributes(period_id: nil, period_format: nil)
    end
  end

end

# == Schema Information
#
# Table name: periods
#
#  id         :integer          not null, primary key
#  event_id   :integer
#  position   :integer
#  start      :datetime
#  finish     :datetime
#  rsvp_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

