require 'date'
require 'time'

class DataFile < ActiveRecord::Base

  TYPES = /^xls|doc|png|jpg|gif|zip|60r|sin|pdf|odf|txt|ppt|ogg|vcf$/

  # ----- Attributes -----
  attr_accessible :data, :download_count
  attr_accessible :data_file_name
  attr_accessible :data_file_size
  attr_accessible :data_file_extension
  attr_accessible :data_content_type
  attr_accessible :data_updated_at

  # ----- Associations -----
  belongs_to        :member
  has_attached_file :data

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

  def cleanup_filename
    self.data_file_name = self.data_file_name.gsub(' ', '_')
  end

  def set_extension
    self.data_file_extension = self.data_file_name.split('.').last.downcase
  end

  # ----- Class Methods -----

end
