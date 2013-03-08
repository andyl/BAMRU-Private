require 'date'
require 'time'

class DataFile < ActiveRecord::Base

  TYPES = /^xls|eps|doc|png|jpg|gif|zip|60r|sin|pdf|odf|txt|ppt|ogg|vcf|htm|html$/

  # ----- Attributes -----
  attr_accessible :data, :download_count
  attr_accessible :data_file_name
  attr_accessible :data_file_size
  attr_accessible :data_file_extension
  attr_accessible :data_content_type
  attr_accessible :data_updated_at
  attr_accessible :event_id, :member_id, :caption

  # ----- Associations -----
  belongs_to        :member
  belongs_to        :event
  has_attached_file :data,
                    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
                    :url  => "/system/:attachment/:id/:style/:filename"

  # ----- Validations -----
  validates_uniqueness_of :data_file_name
  validates_format_of     :data_file_name,      :with => /^[^ ]+$/
  validates_format_of     :data_file_extension, :with => TYPES

  validates_numericality_of :data_file_size, :greater_than => 0, :less_than => 25.megabytes

  # ----- Callbacks -----
  before_validation :set_extension, :cleanup_filename

  # ----- Scopes -----

  # ----- Instance Methods -----
  def export
    atts = attributes
    %w(id member_id).each {|a| atts.delete(a)}
    atts
  end

  def valid_filetypes
    TYPES.to_s[8..-3].gsub('|', ', ')
  end

  def cleanup_filename
    self.data_file_name = self.data_file_name.gsub(' ', '_')
  end

  def set_extension
    self.data_file_extension = self.data_file_name.split('.').last.downcase
  end

  # ----- Class Methods -----

end

# == Schema Information
#
# Table name: data_files
#
#  id                  :integer          not null, primary key
#  member_id           :integer
#  download_count      :integer          default(0)
#  data_file_extension :string(255)
#  data_file_name      :string(255)
#  data_file_size      :string(255)
#  data_content_type   :string(255)
#  data_updated_at     :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  position            :integer
#  event_id            :integer
#  caption             :string(255)
#  published           :boolean          default(FALSE)
#

