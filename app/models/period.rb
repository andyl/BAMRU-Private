class Period < ActiveRecord::Base

  # ----- Associations -----

  belongs_to   :event
  has_many     :participants,  :dependent => :destroy
  has_many     :event_reports, :dependent => :destroy
  has_many     :period_pages
  acts_as_list :scope => :position


  # ----- Callbacks -----

  after_create :create_smso_aar_event_report


  # ----- Validations -----



  # ----- Scopes -----



  # ----- Local Methods-----

  def create_smso_aar_event_report
    return if %w(social).include? self.event.typ
    if self.event_reports.smso_aars.all.empty?
      title = self.event.typ == "meeting" ? "Meeting AAR" : "Period #{self.position} AAR"
      opts = {typ: "smso_aar", event_id: self.event.id, title: title}
      opts[:unit_leader] = "John Chang"
      opts[:signed_by]   = "Eszter Tompos"
      opts[:description] = self.event.description
      puts "CREATING EVENT REPORT FOR PERIOD ##{self.id}"
      self.event_reports << EventReport.create(opts)
    end
  end


end


# == Schema Information
#
# Table name: periods
#
#  id         :integer         not null, primary key
#  event_id   :integer
#  position   :integer
#  start      :datetime
#  finish     :datetime
#  rsvp_id    :integer
#  created_at :datetime
#  updated_at :datetime
#
