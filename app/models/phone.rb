class Phone < ActiveRecord::Base

  # ----- Associations -----
  belongs_to :member
  has_many   :outbound_mails
  
  acts_as_list :scope => :member_id


  # ----- Callbacks -----


  # ----- Validations -----
  validates_format_of :number, :with => /^\d\d\d-\d\d\d-\d\d\d\d$/


  # ----- Scopes -----
  scope :pagable, where(:pagable => 1)
  scope :non_standard, where('typ <> "Work"').
                       where('typ <> "Home"').
                       where('typ <> "Mobile"').
                       where('typ <> "Pager"').
                       where('typ <> "Other"')

  scope :mobile, where(:typ => "Mobile").order("position ASC")

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

end

# == Schema Information
#
# Table name: phones
#
#  id         :integer         not null, primary key
#  member_id  :integer
#  typ        :string(255)
#  number     :string(255)
#  pagable    :string(255)
#  sms_email  :string(255)
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

# == Schema Information
#
# Table name: phones
#
#  id         :integer         not null, primary key
#  member_id  :integer
#  typ        :string(255)
#  number     :string(255)
#  pagable    :string(255)
#  sms_email  :string(255)
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

