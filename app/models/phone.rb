class Phone < ActiveRecord::Base

  # ----- Attributes -----
  attr_accessible :typ, :member_id, :number, :pagable, :sms_email, :position

  # ----- Associations -----
  belongs_to :member
  has_many   :outbound_mails
  
  acts_as_list :scope => :member_id


  # ----- Callbacks -----

  # ----- Validations -----
  validates_format_of   :number, :with => /^\d\d\d-\d\d\d-\d\d\d\d$/
  #validates_presence_of :member_id


  # ----- Scopes -----
  scope :pagable, -> { where(:pagable => '1') }
  scope :non_standard, -> { where("typ <> 'Work'").
                            where("typ <> 'Home'").
                            where("typ <> 'Mobile'").
                            where("typ <> 'Pager'").
                            where("typ <> 'Other'") }

  scope :mobile,     -> { where(:typ => 'Mobile').order("position ASC") }
  scope :home,       -> { where(:typ => 'Home').order("position ASC") }
  scope :work,       -> { where(:typ => 'Work').order("position ASC") }

  # ----- Local Methods-----
  def export
    atts = attributes
    %w(id member_id).each {|a| atts.delete(a)}
    atts
  end

  def non_standard_typ?
    ! %w(Work Home Mobile Pager Other).include?(typ)
  end

  def output
    extra = pagable? ? "/Pagable" : ""
    "#{number} (#{typ}#{extra})"
  end

  def pagable?
    self.pagable == '1'
  end

  def typ_opts
    base_opts = %w(Mobile Home Work Pager Other)
    if typ.nil? || base_opts.include?(typ)
      base_opts
    else
      [typ] + base_opts
    end
  end

  def email_address
    sms_email
  end

  def email_org
    sms_email.split('@').last.try(:downcase)
  end

  def sanitized_number
    tmp = number.strip.gsub(' ','').gsub('-','')
    return tmp if tmp.length == 11
    "1" + tmp
  end

end

# == Schema Information
#
# Table name: phones
#
#  id         :integer          not null, primary key
#  member_id  :integer
#  typ        :string(255)
#  number     :string(255)
#  pagable    :string(255)
#  sms_email  :string(255)
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

