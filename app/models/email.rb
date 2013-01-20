class Email < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :member
  has_many   :outbound_mails
  acts_as_list :scope => :member_id


  # ----- Callbacks -----


  # ----- Validations -----
  validates_format_of :address, :with => /^[A-z0-9\-\_\.]+@([A-z0-9\-\_]+\.)+[A-z]+$/

  validates_uniqueness_of :address

  # ----- Scopes -----
  scope :pagable, where(:pagable => '1')
  scope :non_standard, -> { where("typ <> 'Work'").
                           where("typ <> 'Home'").
                           where("typ <> 'Personal'").
                           where("typ <> 'Other'") }

  scope :personal, -> { where(:typ => 'Personal').order("position ASC") }
  scope :home,     -> { where(:typ => 'Home').order("position ASC") }
  scope :work,     -> { where(:typ => 'Work').order("position ASC") }


  # ----- Local Methods-----
  def export
    atts = attributes
    %w(id member_id).each {|a| atts.delete(a)}
    atts
  end

  def pagable?
    self.pagable == '1'
  end
  
  def non_standard_typ?
    ! %w(Work Home Personal Other).include?(typ)
  end

  def output
    extra = pagable? ? "/Pagable" : ""
    "#{address} (#{typ}#{extra})"
  end

  def typ_opts
    base_opts = %w(Personal Work Other)
    if typ.nil? || base_opts.include?(typ)
      base_opts
    else
      [typ] + base_opts
    end
  end

  def email_address
    address
  end

  def email_org
    address.split('@').last.try(:downcase)
  end

end

# == Schema Information
#
# Table name: emails
#
#  id         :integer         not null, primary key
#  member_id  :integer
#  typ        :string(255)
#  pagable    :string(255)
#  address    :string(255)
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

