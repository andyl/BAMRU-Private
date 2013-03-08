class Role < ActiveRecord::Base

  # ----- Associations -----


  
  # ----- Callbacks -----



  # ----- Validations -----

  # ----- Scopes -----
  scope :bd, -> { where(:typ => "Bd")  }
  scope :ol, -> { where(:typ => "OL")  }

  # ----- Local Methods-----
  def export
    atts = attributes
    %w(id member_id).each {|a| atts.delete(a)}
    atts
  end


end

# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  member_id  :integer
#  typ        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

