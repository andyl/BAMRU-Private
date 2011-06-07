class Email < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :member
  acts_as_list :scope => :member_id


  # ----- Callbacks -----


  # ----- Validations -----
  validates_format_of :address, :with => /^[A-z0-9\-\.\@]+$/


  # ----- Scopes -----
  scope :pagable, where(:pagable => 1)


  # ----- Local Methods-----
  def output
    "#{address} (#{typ})"
  end

end
