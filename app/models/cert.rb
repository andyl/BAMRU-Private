require 'date'
require 'time'

class Cert < ActiveRecord::Base
#  has_attached_file :document,
#                    :styles => {:medium => "300x300>", :thumb => "100x100>" }

  # ----- Attributes -----
  attr_accessible :link, :doc_file, :typ, :comment
  attr_accessible :description, :expiration

  # ----- Associations -----
  belongs_to :member

  # ----- Validations -----

  # ----- Callbacks -----

  # ----- Scopes -----
  scope :medical,    where(:typ => "medical")
  scope :cpr,        where(:typ => "cpr")
  scope :ham,        where(:typ => "ham")
  scope :tracking,   where(:typ => "tracking")
  scope :avalanche,  where(:typ => "avalanche")
  scope :rigging,    where(:typ => "rigging")
  scope :ics,        where(:typ => "ics")
  scope :overhead,   where(:typ => "overhead")
  scope :driver,     where(:typ => "driver")
  scope :background, where(:typ => "background")

  scope :with_pdfs, where("doc_file like ?", "%pdf")
  scope :with_jpgs, where("doc_file like ?", "%jpg")
  scope :with_docs, where("doc_file <> ''")

  # ----- Instance Methods -----
  def doc_url
    "http://bamru.org/private/page/certification/user_images/#{doc_file}"
  end

  def doc_path
    base = File.dirname(File.expand_path(__FILE__))
    base + "/../../db/docs/#{doc_file}"
  end

  def final_doc_file
    doc_file.gsub("pdf", "jpg")
  end

  def final_doc_path
    base = File.dirname(File.expand_path(__FILE__))
    base + "/../../db/docs/#{final_doc_file}"
  end

  def current?
    date_to_time(expiration) > Time.now.to_time
  end

  def date_to_time(date)
    return nil if date.nil?
    date_string = "#{date.year}-#{date.month}-#{date.day}"
    Time.parse(date_string)
  end

  def expire_color
    xdate = date_to_time(expiration)
    return "white"  if xdate.nil?
    return "red"    if xdate < Time.now.to_time
    return "orange" if xdate < 1.month.from_now.to_time
    return "yellow" if xdate < 3.months.from_now.to_time
    "#33ff00"
  end

  def display
    return "<td></td>" if description.blank?
    "<td align=center style='background-color: #{expire_color};'>#{description}</td>"
  end

  # ----- Class Methods -----

end
