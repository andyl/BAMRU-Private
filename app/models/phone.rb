class Phone < ActiveRecord::Base

  # ----- Associations -----
  belongs_to :member
  acts_as_list :scope => :member_id


  # ----- Callbacks -----


  # ----- Validations -----
  validates_format_of :number, :with => /^[0-9\-]+$/


  # ----- Scopes -----
  scope :pagable, where(:pagable => 1)

  
  # ----- Local Methods-----
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
