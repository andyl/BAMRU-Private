class Message < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :author,     :class_name => 'Member'
  has_many   :distributions
  has_many   :recipients, :through => :distributions, :source => :member

  accepts_nested_attributes_for :distributions, :allow_destroy => true

  # ----- Callbacks -----


  # ----- Validations -----


  # ----- Scopes -----


  # ----- Local Methods-----


  # ----- Class Methods

  def self.devices(array)
    array.reduce({}) do |a,v|
      a[v] = true
      a
    end
  end

  def self.distributions_params(hash)
    int1 = hash.keys.map {|k| k.split('_')}
    int2 = int1.reduce({}) do |a,v|
      a[v.first] = ((a[v.first] || []) << v.last).uniq
      a
    end
    int2.keys.reduce([]) do |a,v|
      a << {:member_id => v}.merge(devices(int2[v]))
      a
    end
  end

end

# == Schema Information
#
# Table name: messages
#
#  id         :integer         not null, primary key
#  author_id  :integer
#  ip_address :string(255)
#  text       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

