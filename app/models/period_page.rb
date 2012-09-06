class PeriodPage < ActiveRecord::Base

  # ----- Associations -----
  belongs_to   :period
  belongs_to   :page

  # ----- Callbacks -----


  # ----- Validations -----


  # ----- Scopes -----


  # ----- Local Methods-----


end


# == Schema Information
#
# Table name: period_pages
#
#  id         :integer         not null, primary key
#  period_id  :integer
#  page_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

