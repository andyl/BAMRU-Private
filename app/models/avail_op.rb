class AvailOp < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :member


  # ----- Callbacks -----
  before_validation :check_dates



  # ----- Validations -----
  validates_presence_of :start
  validates_presence_of :end



  # ----- Scopes -----
  scope :current, where("start < ?", Time.now).where("end > ?", Time.now)


  # ----- Local Methods-----
  def check_dates
    self.end, self.start = self.start, self.end if self.end < self.start
  end


end
