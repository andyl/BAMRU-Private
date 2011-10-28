require 'date'
require 'time'

class Cert < ActiveRecord::Base

  # ----- Attributes -----
  attr_accessible :link, :cert_file, :typ, :comment
  attr_accessible :description, :expiration
  attr_accessible :cert
  attr_accessible :cert_file_name, :cert_content_type
  attr_accessible :cert_file_size, :cert_updated_at
  attr_accessible :ninety_day_notice_sent_at
  attr_accessible :thirty_day_notice_sent_at
  attr_accessible :expired_notice_sent_at

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

  # ----- Callbacks -----
  before_validation :cleanup_fields
  before_save       :cleanup_fields
  before_save       :clear_notice_timestamps, :unless => :timestamps_changed?

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

  scope :ninety_day, where("expiration <= ? AND expiration > ?", Date.today + 90, Date.today + 30)
  scope :thirty_day, where("expiration <= ? AND expiration > ?", Date.today + 30, Date.today)
  scope :expired,    where("expiration <= ?", Date.today)

  scope :ninety_day_notified, ninety_day.where("ninety_day_notice_sent_at != ''")
  scope :thirty_day_notified, thirty_day.where("thirty_day_notice_sent_at != ''")
  scope :expired_notified,    expired.where("expired_notice_sent_at != ''")

  scope :ninety_day_not_notified, ninety_day.where(:ninety_day_notice_sent_at => nil)
  scope :thirty_day_not_notified, thirty_day.where(:thirty_day_notice_sent_at => nil)
  scope :expired_not_notified,    expired.where(:expired_notice_sent_at => nil)

  scope :pending_and_expired,   where("expiration <= ?", Date.today + 90)
  scope :pending,               pending_and_expired - expired

  def self.oldest
    order("expiration ASC").last
  end

  def self.newest
    where('expiration <> ""').order("expiration ASC").first
  end

  # ----- Instance Methods -----
  def timestamps_changed?
    self.ninety_day_notice_sent_at_changed? ||
    self.thirty_day_notice_sent_at_changed? ||
    self.expired_notice_sent_at_changed?
  end

  def clear_notice_timestamps
    self.ninety_day_notice_sent_at = nil
    self.thirty_day_notice_sent_at = nil
    self.expired_notice_sent_at    = nil
  end

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
    return ""       if xdate.nil?
    return "pink"   if xdate < Time.now.to_time
    return "orange" if xdate < 1.month.from_now.to_time
    return "yellow" if xdate < 3.months.from_now.to_time
    "lightgreen"
  end

  def description_with_link
    return "<a href='#{link}'            class=blue_link target='_blank'>#{description}</a>"                                              unless link.blank?
    return "<a href='#{cert.url(:full)}' class=blue_link target='_blank'>#{description}</a>"                                              unless cert_file_name.blank?
    return "<a href='#'                  class=purple_link data-comment='#{comment}' data-name='#{member.first_name}'>#{description}</a>" unless comment.blank?
    description
  end

  def display_table(count = 1)
    indicator = (count == 1) ? "" : "*"
    if indicator == '*'
      color = member.certs.where(:typ => self.typ).where("id <> #{self.id}").newest.try(:expire_color)
      indicator = "<span style='background-color: #{color}; padding-left: 2px; padding-right: 2px;'>*</span>" unless color.blank?
    end
    return "<td></td>" if description.blank?
    "<td align=center style='background-color: #{expire_color};'>#{description_with_link} #{indicator}</td>"
  end


  # ----- Class Methods -----
  def self.clear_all_notices
    args = {:ninety_day_notice_sent_at => nil,
            :thirty_day_notice_sent_at => nil,
            :expired_notice_sent_at    => nil}
    Cert.all.each {|x| x.update_attributes(args)}
  end

end

# == Schema Information
#
# Table name: certs
#
#  id                :integer         not null, primary key
#  member_id         :integer
#  typ               :string(255)
#  expiration        :date
#  description       :string(255)
#  comment           :string(255)
#  link              :string(255)
#  position          :integer
#  cert_file         :string(255)
#  cert_file_name    :string(255)
#  cert_content_type :string(255)
#  cert_file_size    :string(255)
#  cert_updated_at   :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

