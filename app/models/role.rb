class Role < ActiveRecord::Base

  # ----- Attributes -----
  attr_accessible :typ, :member_id

  # ----- Associations -----

  belongs_to :member


  # ----- Scopes -----
  scope :bds, -> { where(:typ => "Bd")  }
  scope :ols, -> { where(:typ => "OL")  }

  def self.by_typ(typ)
    where(typ: typ)
  end

  # ----- Callbacks -----


  # ----- Validations -----


  # ----- Class Methods -----

  def self.assign_role(role, member)
    return if %w(Bd OL).include? role
    mem_id = member.is_a?(Integer) ? member : member.id
    by_typ(role).all.each {|x| x.destroy}
    create typ: role, member_id: mem_id
  end

  def self.member_for(role)
    by_typ(role).try(:first).try(:member)
  end

  def self.role_assignments
    [
      %w(UL  Chang),
      %w(XO  Frantz),
      %w(OO  Barbour),
      %w(SEC Tompos),
      %w(TO  Kantarjiev),
      %w(RO  Farrand),
      %w(TRS Hoagland),
      %w(REG Allen),
      %w(WEB Leak)
    ]
  end

  def self.assign_roles
    role_assignments.each do |x|
      assign_role x.first, Member.by_last_name(x.last)
    end
  end

  # ----- Local Methods-----
  def export
    atts = attributes
    %w(id member_id).each {|a| atts.delete(a)}
    atts
  end


end

# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  member_id  :integer
#  typ        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

