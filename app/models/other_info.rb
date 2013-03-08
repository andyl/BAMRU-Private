class OtherInfo < ActiveRecord::Base

  attr_accessible :position, :label, :value

  # ----- Associations -----

  belongs_to :member
  acts_as_list :scope => :member_id


  # ----- Callbacks -----


  # ----- Validations -----


  # ----- Scopes -----


  # ----- Local Methods-----
  def export
    atts = attributes
    %w(id member_id).each {|a| atts.delete(a)}
    atts
  end

  def output
    "#{label} / #{value}"
  end

end

# == Schema Information
#
# Table name: other_infos
#
#  id         :integer          not null, primary key
#  member_id  :integer
#  label      :string(255)
#  value      :string(255)
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

