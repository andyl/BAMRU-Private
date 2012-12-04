class EventLink < ActiveRecord::Base

  # ----- Associations -----
  belongs_to   :event

  has_attached_file :link_backup,
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url  => "/system/:attachment/:id/:style/:filename"

  # ----- Callbacks -----


  # ----- Validations -----


  # ----- Scopes -----


  # ----- Local Methods-----


end


# == Schema Information
#
# Table name: event_links
#
#  id         :integer         not null, primary key
#  member_id  :integer
#  event_id   :integer
#  site_url   :string(255)
#  caption    :string(255)
#  published  :boolean         default(FALSE)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

