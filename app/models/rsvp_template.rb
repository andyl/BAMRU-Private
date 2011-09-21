class RsvpTemplate < ActiveRecord::Base

  # ----- Associations -----



  # ----- Callbacks -----



  # ----- Validations -----



  # ----- Scopes -----



  # ----- Local Methods-----

  def output_json
    atts = [:prompt, :yes_prompt, :no_prompt]
    Hash[atts.map { |name, _| [name, read_attribute(name)] }].to_json
  end

end



# == Schema Information
#
# Table name: rsvp_templates
#
#  id         :integer         not null, primary key
#  position   :integer
#  name       :string(255)
#  prompt     :string(255)
#  yes_prompt :string(255)
#  no_prompt  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

