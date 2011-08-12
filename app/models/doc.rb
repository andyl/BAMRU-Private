require 'date'
require 'time'

class Doc < ActiveRecord::Base

  TYPES = /^xls|doc|png|jpg|gif|zip|60r|sin|pdf|odf|txt|ppt|ogg|vcf$/

  # ----- Attributes -----
  attr_accessible :doc, :download_count
  attr_accessible :doc_file_name, :doc_content_type
  attr_accessible :doc_file_size, :doc_updated_at
  attr_accessible :doc_file_extension

  # ----- Associations -----
  belongs_to :member
  has_attached_file :doc

  # ----- Validations -----
  validates_uniqueness_of :doc_file_name
  validates_format_of     :doc_file_name,      :with => /^[^ ]+$/
  validates_format_of     :doc_file_extension, :with => TYPES

  validates_attachment_size :doc, :less_than => 25.megabytes

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
    self.doc_file_name = self.doc_file_name.gsub(' ', '_')
  end

  def set_extension
    self.doc_file_extension = self.doc_file_name.split('.').last.downcase
  end

  # ----- Class Methods -----

end
