class Email < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :member
  acts_as_list :scope => :member_id


  # ----- Callbacks -----


  # ----- Validations -----
  validates_format_of :address, :with => /^[A-z0-9\-\.\@]+$/


  # ----- Scopes -----
  scope :pagable, where(:pagable => 1)


  # ----- Local Methods-----
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
