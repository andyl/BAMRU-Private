require 'date'
require 'time'

class AvailOp < ActiveRecord::Base

  # ----- Attributes -----
  attr_accessible :start, :end, :comment
  attr_accessible :start_txt,   :end_txt

  # ----- Associations -----
  belongs_to :member


  # ----- Callbacks -----
  before_validation :cleanup_dates

  # ----- Validations -----
  validates_presence_of :start
  validates_presence_of :end

  # ----- Scopes -----
  scope :current, where("start < ?", Time.now).where("end > ?", Time.now)

  # ----- Attr Accessors -----
  def start_txt
    self.start.strftime("%Y-%m-%d")
  end

  def end_txt
    self.end.strftime("%Y-%m-%d")
  end

  def start_txt=(date)
    self.start = Time.parse(date)
  end

  def end_txt=(date)
    self.end = Time.parse(date)
  end

  # ----- Local Methods-----
  def cleanup_dates
    return if self.end.blank? || self.start.blank?
    self.end, self.start = self.start, self.end if self.end < self.start
  end

  # ----- Class Methods -----
  def self.busy_on?(date)
    date = date.to_date if date.is_a?(Time)
    result = where("start < ?", date+1).where("end >= ?", date).count
    result == 0 ? false : true
  end


end
