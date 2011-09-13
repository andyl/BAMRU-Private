class EmergencyContact < ActiveRecord::Base

  attr_accessible :position, :name, :number, :typ

  # ----- Associations -----
  belongs_to :member
  acts_as_list :scope => :member_id


  # ----- Callbacks -----


  # ----- Validations -----
  validates_presence_of :name, :number
  validates_format_of :number, :with => /^\d\d\d-\d\d\d-\d\d\d\d$/


  # ----- Scopes -----


  # ----- Local Methods-----
  def export
    atts = attributes
    %w(id member_id).each {|a| atts.delete(a)}
    atts
  end

  def output
    "#{name} / #{number} (#{typ})"
  end

end

# == Schema Information
#
# Table name: emergency_contacts
#
#  id         :integer         not null, primary key
#  member_id  :integer
#  name       :string(255)
#  number     :string(255)
#  typ        :string(255)
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

