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


