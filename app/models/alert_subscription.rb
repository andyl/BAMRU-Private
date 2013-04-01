class AlertSubscription < ActiveRecord::Base

  # ----- Attributes -----
  attr_accessible :event_typ, :role_typ

  # ----- Associations -----


  # ----- Callbacks -----


  # ----- Validations -----


  # ----- Scopes -----

  def self.for(event, role)
    where(event_typ: event).where(role_typ: role).all.try(:first)
  end


  # ----- Local Methods-----


  # ----- Class Methods -----

  def self.create_for(event, role)
    destroy_all(event, role)
    create(event_typ: event, role_typ: role)
  end

  def self.destroy_all(event, role)
    where(event_typ: event).where(role_typ: role).all.each do |sub|
      sub.destroy
    end
  end

end
