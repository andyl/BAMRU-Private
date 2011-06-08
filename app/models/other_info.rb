class OtherInfo < ActiveRecord::Base

  attr_accessible :position, :label, :value

  # ----- Associations -----

  belongs_to :member
  acts_as_list :scope => :member_id


  # ----- Callbacks -----


  # ----- Validations -----


  # ----- Scopes -----


  # ----- Local Methods-----

  def output
    "#{label} / #{value}"
  end

end
