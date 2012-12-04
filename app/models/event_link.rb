class EventLink < ActiveRecord::Base

  # ----- Associations -----
  belongs_to   :event

  has_attached_file :link_backup,
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url  => "/system/:attachment/:id/:style/:filename"

  # ----- Callbacks -----


  # ----- Validations -----


  # ----- Scopes -----


  # ----- Instance Methods-----

  def site_domain
    self.site_url.split('/')[2]
  end

  def generate_backup
    clean_domain = self.site_domain.gsub('.','_')
    kit = PDFKit.new(self.site_url)
    timestamp = Time.now.strftime("%Y-%m-%d_%H-%M")
    filepath = "/tmp/#{clean_domain}_#{timestamp}.pdf"
    kit.to_file(filepath)
    self.link_backup = File.new(filepath, 'r')
    self.save
  end

  def backup_url
    self.link_backup.url
  end


end


# == Schema Information
#
# Table name: event_links
#
#  id                       :integer         not null, primary key
#  member_id                :integer
#  event_id                 :integer
#  site_url                 :string(255)
#  caption                  :string(255)
#  published                :boolean         default(FALSE)
#  link_backup_file_name    :string(255)
#  link_backup_content_type :string(255)
#  link_backup_file_size    :integer
#  link_backup_updated_at   :integer
#  created_at               :datetime
#  updated_at               :datetime
#

