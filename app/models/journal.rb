class Journal < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :member
  belongs_to :distribution


  # ----- Callbacks -----


  # ----- Validations -----


  # ----- Scopes -----


  # ----- Local Methods-----


  # ----- Class Methods -----

  # Adds a new Journal entry
  #
  # @param distribution [Distribution] Distribution or distribution_id
  # @param member [Member] Member or member_id
  # @param comment [String] Journal comment
  # @return [Journal] returns the created Journal
  def self.add_entry(distribution, member, comment)
    dist_id = distribution.is_a?(Integer) ? distribution : distribution.id
    memb_id = member.is_a?(Integer) ? member : member.id
    hash = {
            distribution_id: dist_id,
            member_id: memb_id,
            action: comment
    }
    Journal.create(hash)
  end

end

# == Schema Information
#
# Table name: journals
#
#  id              :integer          not null, primary key
#  member_id       :integer
#  distribution_id :integer
#  action          :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

