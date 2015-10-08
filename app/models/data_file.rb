require 'date'
require 'time'

class DataFile < ActiveRecord::Base

  TYPES = /^xls|eps|doc|png|jpg|gif|zip|60r|sin|pdf|odf|txt|ppt|ogg|vcf|htm|html$/

  # ----- Attributes -----
  attr_accessible :data
  attr_accessible :data_file_name
  attr_accessible :data_file_size
  attr_accessible :data_file_extension
  attr_accessible :data_content_type
  attr_accessible :data_updated_at
  attr_accessible :download_count
  attr_accessible :member_id
  attr_accessible :caption

  # ----- Associations -----
  belongs_to        :member
  has_many          :event_files, :dependent => :destroy
  has_many          :events,      :through => :event_files
  has_attached_file :data,
                    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
                    :url  => "/system/:attachment/:id/:style/:filename"

  # ----- Validations -----
  validates_uniqueness_of :data_file_name
  validates_format_of     :data_file_name,      :with => /^[^ ]+$/
  validates_format_of     :data_file_extension, :with => TYPES

  validates_numericality_of :data_file_size, :greater_than => 0, :less_than => 35.megabytes

  # ----- Callbacks -----
  before_validation :set_extension, :cleanup_filename

  # ----- Scopes -----

  def self.with_filename(filename, objid = nil)
    if objid.nil?
      where(data_file_name: File.basename(filename))
    else
      where(data_file_name: File.basename(filename)).where('id != ?', objid)
    end
  end

  def self.with_filename_like(filename)
    base = File.basename filename, '.*'
    ext  = File.extname  filename
    where("data_file_name LIKE '#{base}_%#{ext}'")
  end

  def self.filenames
    select(['data_file_name']).all.map {|x| x.data_file_name}
  end

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
    increment_filename if duplicate_filename?
  end

  def set_extension
    self.data_file_extension = File.extname(self.data_file_name).downcase.gsub('.','')
  end

  def duplicate_filename?
    DataFile.with_filename(self.data_file_name, self.id).count > 0
  end

  private

  def increment_filename
    base = File.basename(self.data_file_name, '.*')
    ext  = File.extname(self.data_file_name)
    related = DataFile.with_filename_like(self.data_file_name).filenames
    self.data_file_name = if related.blank?
                            "#{base}_1#{ext}"
                          else
                            max_ext = related.map {|x| get_num(x) }.max
                            "#{base}_#{max_ext + 1}#{ext}"
                          end
  end

  def get_num(filename)
    File.basename(filename, '.*').split('_').last.to_i
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
#  killme1             :integer
#  killme2             :integer
#  caption             :string(255)
#  published           :boolean          default(FALSE)
#

