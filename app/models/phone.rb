class Phone < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :user

  # ----- Callbacks -----

  # ----- Validations -----

  # ----- Scopes -----
  scope :pagable, where(:pagable => 1)

  # ----- Local Methods-----
  def output
    "#{number} (#{typ})"
  end

end
