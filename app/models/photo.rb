class Photo < ActiveRecord::Base

  # ----- Associations -----
  belongs_to   :member
  acts_as_list :scope => :member_id

  has_attached_file :image, :styles => {:medium => "300x300", :roster => "150x150", :thumb => "100x100", :icon => "30x30"}

  # ----- Callbacks -----



  # ----- Validations -----



  # ----- Scopes -----



  # ----- Local Methods-----
  def export
    atts = attributes
    %w(id member_id).each {|a| atts.delete(a)}
    atts
  end


end

# == Schema Information
#
# Table name: photos
#
#  id                 :integer         not null, primary key
#  member_id          :integer
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :integer
#  position           :integer
#  created_at         :datetime
#  updated_at         :datetime
#

