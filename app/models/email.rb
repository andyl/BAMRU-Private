class Email < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :member
  acts_as_list :scope => :member_id


  # ----- Callbacks -----


  # ----- Validations -----
  validates_format_of :address, :with => /^[A-z0-9\-\_\.]+@([A-z0-9\-\_]+\.)+[A-z]+$/

  validates_uniqueness_of :address

  # ----- Scopes -----
  scope :pagable, where(:pagable => 1)
  scope :non_standard, where('typ <> "Work"').
                       where('typ <> "Home"').
                       where('typ <> "Personal"').
                       where('typ <> "Other"')

  # ----- Local Methods-----
  def non_standard_typ?
    ! %w(Work Home Personal Other).include?(typ)
  end

  def output
    "#{address} (#{typ})"
  end

  def typ_opts
    base_opts = %w(Personal Work Other)
    if typ.nil? || base_opts.include?(typ)
      base_opts
    else
      [typ] + base_opts
    end
  end

end
