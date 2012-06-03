require 'date'
require 'time'

class AvailOp < ActiveRecord::Base

  # ----- Attributes -----
  attr_accessible :start_on, :end_on, :comment
  attr_accessible :start_txt,   :end_txt

  # ----- Associations -----
  belongs_to :member

  # ----- Callbacks -----
  before_validation :cleanup_dates

  # ----- Validations -----
  validates_presence_of :start_on
  validates_presence_of :end_on

  # ----- Scopes -----
  scope :current, where("start_on < ?", Time.now).where("end_on > ?", Time.now)
  scope :older_than_this_month, where("end_on < ?", Time.now.beginning_of_month)


  # ----- Attr Accessors -----
  def start_txt
    self.start_on.strftime("%Y-%m-%d")
  end

  def end_txt
    self.end_on.strftime("%Y-%m-%d")
  end

  def start_txt=(date)
    self.start_on = Time.parse(date)
  end

  def end_txt=(date)
    self.end_on = Time.parse(date)
  end

  # ----- Local Methods-----
  def export
    atts = attributes
    %w(id member_id).each {|a| atts.delete(a)}
    atts
  end
  
  def cleanup_dates
    return if self.end_on.blank? || self.start_on.blank?
    self.end_on, self.start_on = self.start_on, self.end_on if self.end_on < self.start_on
  end

  # ----- Class Methods -----
  def self.busy_on?(date)
    date = date.to_date if date.is_a?(Time)
    result = where("start_on < ?", date+1).where("end_on >= ?", date).count
    result == 0 ? false : true
  end

  def self.return_date(date)
    date = date.to_date if date.is_a?(Time)
    result = where("start_on < ?", date+1).where("end_on >= ?", date).last
    result.nil? ? nil : result.end_on
  end


end

# == Schema Information
#
# Table name: avail_ops
#
#  id         :integer         not null, primary key
#  member_id  :integer
#  start_on   :date
#  end_on     :date
#  comment    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

