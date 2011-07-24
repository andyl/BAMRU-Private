class Phone < ActiveRecord::Base

  # ----- Associations -----
  belongs_to :member
  acts_as_list :scope => :member_id


  # ----- Callbacks -----


  # ----- Validations -----
  validates_format_of :number, :with => /^\d\d\d-\d\d\d-\d\d\d\d$/


  # ----- Scopes -----
  scope :pagable, where(:pagable => 1)
  scope :non_standard, where('typ <> "Work"').
                       where('typ <> "Home"').
                       where('typ <> "Mobile"').
                       where('typ <> "Other"')

  # ----- Local Methods-----
  def export
    atts = attributes
    %w(id member_id).each {|a| atts.delete(a)}
    atts
  end

  def non_standard_typ?
    ! %w(Work Home Mobile Other).include?(typ)
  end

  def output
    "#{number} (#{typ})"
  end

  def typ_opts
    base_opts = %w(Mobile Home Work Other)
    if typ.nil? || base_opts.include?(typ)
      base_opts
    else
      [typ] + base_opts
    end
  end

end
