class Phone < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :member

  # ----- Callbacks -----

  # ----- Validations -----

  # ----- Scopes -----
  scope :pagable, where(:pagable => 1)

  # ----- Local Methods-----
  def output
    "#{number} (#{typ})"
  end

end
