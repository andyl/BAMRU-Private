class Email < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :user


  # ----- Callbacks -----



  # ----- Validations -----



  # ----- Scopes -----



  # ----- Local Methods-----
  def output
    "#{address} (#{typ})"
  end

end
