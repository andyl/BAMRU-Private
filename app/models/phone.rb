class Phone < ActiveRecord::Base

  # ----- Associations -----
  belongs_to :member


  # ----- Callbacks -----


  # ----- Validations -----
  validates_format_of :number, :with => /^[0-9\-]+$/


  # ----- Scopes -----
  scope :pagable, where(:pagable => 1)

  
  # ----- Local Methods-----
  def output
    "#{number} (#{typ})"
  end

end
