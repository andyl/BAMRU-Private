class Cert < ActiveRecord::Base
#  has_attached_file :document,
#                    :styles => {:medium => "300x300>", :thumb => "100x100>" }

  # ----- Associations -----
  belongs_to :member

  # ----- Validations -----

  # ----- Callbacks -----

  # ----- Scopes -----

  # ----- Instance Methods -----
  def display
    description
  end

  # ----- Class Methods -----

end
