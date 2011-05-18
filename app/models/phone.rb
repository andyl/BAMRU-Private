class Phone < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :user


  # ----- Callbacks -----



  # ----- Validations -----



  # ----- Scopes -----



  # ----- Local Methods-----
  def output
    "#{number} (#{typ})"
  end

end
