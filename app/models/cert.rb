require 'date'
require 'time'

class Cert < ActiveRecord::Base

  # ----- Attributes -----
  attr_accessible :link, :cert_file, :typ, :comment
  attr_accessible :description, :expiration
  attr_accessible :cert
  attr_accessible :cert_file_name, :cert_content_type
  attr_accessible :cert_file_size, :cert_updated_at

  # ----- Associations -----
  belongs_to :member
  has_attached_file :cert, :styles => {
          :full => {
                  :geometry => '2400x2400',
                  :quality => 600,
                  :format  => "jpg"
          },
          :thumb => "150x150",
          :icon => "25x25"}

  # ----- Validations -----
  validates_presence_of :description

  # ----- Callbacks -----
  before_validation :cleanup_fields
  before_save       :cleanup_fields

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

  scope :with_pdfs, where("cert_file like ?", "%pdf")
  scope :with_jpgs, where("cert_file like ?", "%jpg")
  scope :with_docs, where("cert_file <> ''")

  scope :expired,               where("expiration <= ?", Date.today)
  scope :pending_and_expired,   where("expiration <= ?", Date.today + 90)
  scope :pending,               pending_and_expired - expired

  # ----- Instance Methods -----
  def export
    atts = attributes
    %w(id member_id).each {|a| atts.delete(a)}
    atts
  end

  def cleanup_fields
    self.typ = self.typ.downcase
    self.description = "Certified" if self.typ == "driver"
  end

  def cert_url
    "http://bamru.org/private/page/certification/user_images/#{cert_file}"
  end

  def cert_path
    base = File.dirname(File.expand_path(__FILE__))
    base + "/../../db/seed/certs/#{cert_file}"
  end

  def final_cert_file
    cert_file.gsub("pdf", "jpg")
  end

  def final_cert_path
    base = File.dirname(File.expand_path(__FILE__))
    base + "/../../db/seed/certs/#{final_cert_file}"
  end

  def current?
    expiration.nil? ? true : (expiration > Date.today)
  end

  def status
    return "Expired" if self.expiration < Date.today
    return "Pending" if self.expiration < Date.today + 90
    return "Active"
  end

  def date_to_time(date)
    return nil if date.nil?
    date_string = "#{date.year}-#{date.month}-#{date.day}"
    Time.parse(date_string)
  end

  def expire_color
    xdate = date_to_time(expiration)
    return "white"  if xdate.nil?
    return "pink"   if xdate < Time.now.to_time
    return "orange" if xdate < 1.month.from_now.to_time
    return "yellow" if xdate < 3.months.from_now.to_time
    "lightgreen"
  end

  def description_with_link
    return "<a href='#{link}'>#{description}</a>"     unless link.blank?
    return "<a href='#{cert.url(:full)}'>#{description}</a>" unless cert_file_name.blank?
    description
  end

  def display_table(count = 1)
    indicator = (count == 1) ? "" : "*"
    return "<td></td>" if description.blank?
    "<td align=center style='background-color: #{expire_color};'>#{description_with_link} #{indicator}</td>"
  end


  # ----- Class Methods -----

end
