class EventPhoto < ActiveRecord::Base

  # ----- Attributes -----
  attr_accessible :event_id, :data_photo_id

  # ----- Associations -----
  belongs_to   :event
  belongs_to   :data_photo

  # ----- Callbacks -----

  # ----- Scopes -----

  # see http://railscasts.com/episodes/215-advanced-queries-in-rails-3
  # aka 'non-guests'...
  #scope :registered, -> { joins(:member).merge(Member.registered) }

  # for transit status...
  #scope :has_not_left, -> { where('en_route_at is NULL')             }
  #scope :has_left,     -> { where('en_route_at is not NULL')         }
  #scope :is_en_route,  -> { has_left.where('return_home_at is NULL') }
  #scope :has_returned, -> { where('return_home_at is not NULL')      }

  # ----- Instance Methods -----

end

# == Schema Information
#
# Table name: event_photos
#
#  id            :integer          not null, primary key
#  event_id      :integer
#  data_photo_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

