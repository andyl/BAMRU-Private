class MemberDecorator < ApplicationDecorator
  decorates :member

  def mobile_json
    member_fields = %w(first_name last_name id typ)
    result = subset(model.attributes, member_fields)
    result["full_roles"] = model.full_roles
    result["phones_attributes"] = phone_data if has_phone?
    result["emails_attributes"] = email_data if has_email?
    result.to_json
  end

  def self.mobile_json
    result = Member.order_by_last_name.all.map do |m|
      MemberDecorator.new(m).mobile_json
    end.join(',')
    "[#{result}]"
  end

  private

  def has_phone?() !model.phones.blank?; end
  def has_email?() !model.emails.blank?; end
  def has_photo?() !model.photos.blank?; end
  def has_ham?()   !model.ham.blank?;    end
  def has_v9?()    !model.v9.blank?;     end
  def has_emergency_contacts?() !model.emergency_contacts.blank?; end
  def has_other_infos?()        !model.other_infos.blank?;        end

  def phone_data
    phone_fields = %w(number id typ)
    model.phones.map { |phone| subset(phone.attributes, phone_fields) }
  end

  def email_data
    email_fields = %w(address id typ)
    model.emails.map {|email| subset(email.attributes, email_fields)}
  end
end