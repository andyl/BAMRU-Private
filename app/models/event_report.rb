class EventReport < ActiveRecord::Base

  # ----- Associations -----
  belongs_to   :event
  belongs_to   :period
  belongs_to   :member

  # ----- Callbacks -----


  # ----- Validations -----


  # ----- Scopes -----

  scope :smso_aars,       where(typ: "smso_aar")
  scope :internal_aars,   where(typ: "internal_aar")
  scope :blog_posts,      where(typ: "blog_post")
  scope :contact_list,    where(typ: "contact_list")
  scope :training_packet, where(typ: "training_packet")

  # ----- Local Methods-----

  def template
    case self.typ
      when "smso_aar" then "smso_aar.html"
      else "unknown.html"
    end
  end

end

# == Schema Information
#
# Table name: event_reports
#
#  id         :integer         not null, primary key
#  member_id  :integer
#  event_id   :integer
#  period_id  :integer
#  title      :string(255)
#  data       :text
#  position   :integer
#  published  :boolean         default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

