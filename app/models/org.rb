class Org < ActiveRecord::Base

  # ----- Attributes -----

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name
  attr_accessible :do_assignments_attributes

  # ----- Associations -----
  has_many :do_assignments

  accepts_nested_attributes_for :do_assignments, :allow_destroy => true
#  accepts_nested_attributes_for :phones,    :allow_destroy => true, :reject_if => lambda {|a| a[:number].blank? }

  # ----- Validations -----

  # ----- Callbacks -----

  # ----- Scopes -----

  # ----- Virtual Attributes (Accessors) -----

  # ----- Virtual Attributes (Readers) -----

  def do_assignments_for(year, quarter)
    hash = { :org_id => id, :year => year, :quarter => quarter }
    (1..13).map do |week|
      hash[:week] = week
      DoAssignment.find_or_new(hash)
    end
  end

  # ----- Instance Methods -----


end

# == Schema Information
#
# Table name: orgs
#
#  id   :integer          not null, primary key
#  name :string(255)
#

