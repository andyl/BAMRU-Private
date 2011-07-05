class Member < ActiveRecord::Base

  has_secure_password

  # ----- Attributes -----

  # Setup accessible (or protected) attributes for your model
  attr_accessible :password, :password_confirmation, :remember_me
  attr_accessible :title, :first_name, :last_name, :user_name, :full_name
  attr_accessible :typ, :v9, :ham, :base_role
  attr_accessible :phones_attributes, :addresses_attributes
  attr_accessible :roles_attributes, :emails_attributes, :certs_attributes
  attr_accessible :avail_ops_attributes, :avail_dos_attributes
  attr_accessible :emergency_contacts_attributes
  attr_accessible :other_infos_attributes
  attr_accessible :remember_me_token
  attr_accessible :forgot_password_token, :forgot_password_expires_at
  attr_accessible :bd, :ol, :admin

  # ----- Associations -----
  has_many :addresses,          :order => 'position'
  has_many :phones,             :order => 'position'
  has_many :emails,             :order => 'position'
  has_many :photos,             :order => 'position'
  has_many :other_infos,        :order => 'position'
  has_many :emergency_contacts, :order => 'position'
  has_many :roles
  has_many :certs
  has_many :avail_ops,          :order => 'start'
  has_many :avail_dos
  has_many :messages
  has_many :distributions
  has_many :notices, :through => :distributions, :source => :message

  accepts_nested_attributes_for :addresses, :allow_destroy => true, :reject_if => lambda {|p| Member.invalid_address?(p) }
  accepts_nested_attributes_for :phones,    :allow_destroy => true, :reject_if => lambda {|p| Member.invalid_params?(p, :number) }
  accepts_nested_attributes_for :emails,    :allow_destroy => true, :reject_if => lambda {|p| Member.invalid_params?(p, :address) }
  accepts_nested_attributes_for :roles,     :allow_destroy => true
  accepts_nested_attributes_for :certs,     :allow_destroy => true
  accepts_nested_attributes_for :avail_ops, :allow_destroy => true, :reject_if => lambda {|p| p[:start_txt].blank? && p[:end_txt].blank?}
  accepts_nested_attributes_for :avail_dos, :allow_destroy => true, :reject_if => lambda {|p| Member.invalid_params?(p, :typ) }
  accepts_nested_attributes_for :emergency_contacts, :allow_destroy => true, :reject_if => lambda {|p| Member.invalid_params?(p, [:name, :number])}
  accepts_nested_attributes_for :other_infos,        :allow_destroy => true, :reject_if => lambda {|p| Member.invalid_params?(p, [:name, :number])}

  # ----- Validations -----
  validates_associated    :addresses # ,                        :on => [:create,  :update]
  validates_associated    :phones, :emails,                  :on => [:create,  :update]
  validates_associated    :emergency_contacts, :other_infos, :on => [:create,  :update]

  validates_presence_of   :first_name, :last_name, :user_name
  validates_format_of     :title,      :with => /^[A-Za-z\.]+$/, :allow_blank => true
  validates_format_of     :first_name, :with => /^[A-Za-z]+$/
  validates_format_of     :last_name,  :with => /^[A-Za-z\- ]+$/
  validates_format_of     :user_name,  :with => /^[a-z_\.\-]+$/
  validates_format_of     :password,   :with => /^[A-z0-9]+$/
  validates_uniqueness_of :user_name

  validate :check_full_name_errors

  def check_full_name_errors
    if errors.include?(:first_name) ||
            errors.include?(:last_name)  ||
            errors.include?(:user_name)  ||
            errors.include?(:title)
      errors.add(:full_name, "has errors")
    end
  end

  # ----- Callbacks -----
  before_validation :check_first_name_for_title
  before_validation :set_username_and_name_fields
  before_validation :set_pwd,                  :on => :create
  before_validation :set_remember_me_token,    :if => :password_digest_changed?

  # ----- Scopes -----
  scope :order_by_last_name, order("last_name ASC")
  scope :with_photos,        where("id     IN (SELECT member_id from photos)")
  scope :without_photos,     where("id NOT IN (SELECT member_id from photos)")

  # ----- Virtual Attributes (Accessors) -----

  def full_name
    "#{title.blank? ? "" : title + ' '}#{first_name} #{last_name}"
  end

  def full_name=(input)
    if input.blank?
      self.title = self.first_name = self.last_name = ""
      return
    end
    str = input.split(' ')
    if str[0].include?('.')
      self.title = str[0].try(:capitalize_all)
      self.first_name = str[1].try(:capitalize_all)
      self.last_name = str.length > 1 ? str[2..-1].join(' ').try(:capitalize_all) : ""
    else
      self.title = ""
      self.first_name = str[0].try(:capitalize)
      self.last_name  = str[1] ? str[1..-1].join(' ').try(:capitalize_all) : ""
    end
  end

  def bd
    roles.all.find {|r| r.typ.downcase == "bd"} ? true : false
  end

  def bd=(val)
    if val == "1" || val == true
      unless bd
        roles.create(:typ => "Bd")
      end
    end
    if val == "0" || val == false
      role = roles.bd.first
      role.destroy unless role.blank?
    end
  end

  def ol
    roles.all.find {|r| r.typ.downcase == "ol"} ? true : false
  end

  def ol=(val)
    if val == "1" || val == true
      unless ol
        roles.create(:typ => "OL")
      end
    end
    if val == "0" || val == false
      role = roles.ol.first
      role.destroy unless role.blank?
    end
  end

  # ----- Virtual Attributes (Readers) -----

  def email
    emails.first.try(:address)
  end

  def short_name
    first_initial = first_name[0..0]
    "#{first_initial}. #{last_name}"
  end

  def full_roles
    arr = ([typ] + roles.map {|r| r.typ})
    arr.sort{|x,y| role_val(x) <=> role_val(y)}.join(' ')
  end

  def cert_color_name
    "<span style='color: #{get_cert_color};'>#{full_name}</span>"
  end

  def current_status
    oot = avail_ops.current.all
    oot.blank? ? "" : "unavailable"
  end

  def current_status_comment
    oot = avail_ops.current.all
    oot.blank? ? "" : oot.first.comment
  end

  def avail_dos_for(year, quarter)
    hash = { :member_id => id, :year => year, :quarter => quarter }
    (1..13).map do |week|
      hash[:week] = week
      AvailDo.find_or_new(hash)
    end
  end

  def non_standard_records?
    phones.non_standard.count != 0 ||
    emails.non_standard.count != 0 ||
    addresses.non_standard.count != 0
  end

  # ----- Instance Methods -----

  def clear_password
    self.password = ""
    self.password_confirmation = ""
  end

  def reset_forgot_password_token
    Time.zone = "Pacific Time (US & Canada)"
    self.forgot_password_token      = rand(36 ** 8).to_s(36)
    self.forgot_password_expires_at = Time.zone.now + 30.minutes
    self.save
  end

  def clear_forgot_password_token
    self.forgot_password_token = nil
    self.forgot_password_expires_at = nil
    self.save
  end

  def self.invalid_address?(params)
    tmp = params[:full_address]
    tmp && (tmp.empty? || tmp.include?('...'))
  end

  def self.invalid_params?(params, field)
    fields = field.is_a?(Array) ? field : [field]
    fields.any? {|x| params[x].blank? || params[x].include?('...')}
  end

  def set_remember_me_token
    #debugger
    self.remember_me_token = rand(36 ** 6).to_s(36)
  end

  def check_first_name_for_title
    return if self.first_name.blank?
    return unless self.first_name.include?('.') && self.first_name.include?(" ")
    self.title, self.first_name = self.first_name.split(' ',2)
  end

  def phone(typ)
    phones.where(:typ => typ).first
  end

  def address(typ)
    addresses.where(:typ => typ).first
  end

  def email(typ)
    emails.where(:typ => typ).first
  end

  def get_cert_color
    current_medical_and_cpr? ? "black" : "red"
  end

  def current_medical?
    ! certs.medical.blank? && certs.medical.first.current?
  end

  def current_cpr?
    ! certs.cpr.blank? && certs.cpr.first.current?
  end

  def current_medical_and_cpr?
    current_medical? && current_cpr?
  end

  def new_username_from_names
    return "" if first_name.blank? || last_name.blank?
    fname = self.first_name.downcase.gsub(' ','_').gsub('.','')
    lname = self.last_name.downcase.gsub(' ','_').gsub('.','')
    "#{fname}_#{lname}"
  end

  def set_pwd
    self.password = "welcome" if self.password.blank?
  end

  def new_names_from_username
    return ["",""] if user_name.blank?
    user_name.split('_').map {|n| n.capitalize_all }
  end

  def cleanup_user_names
    self.user_name = self.user_name.downcase unless self.user_name.blank?
    self.first_name = self.first_name.capitalize unless self.first_name.blank?
    self.last_name = self.last_name.capitalize_all unless self.last_name.blank?
  end

  def names_changed?
    self.first_name_changed? || self.last_name_changed?
  end

  def names_blank?
    self.first_name.blank? && self.last_name.blank?
  end

  def set_username_and_name_fields
    self.user_name = new_username_from_names if names_changed?
    self.user_name = new_username_from_names if self.user_name.blank?
    self.first_name, self.last_name = new_names_from_username if names_blank?
    cleanup_user_names
  end

  def email_required?
    false
  end

  def all_related(item, message, separator = "<br/>")
    result = item.map {|a| a.output}.join(separator)
    result.blank? ? "" : "<b>#{message}:</b><br/>#{result}"
  end

  def all_assoc
    p = all_related(phones, "Phones")
    a = all_related(addresses, "Addresses")
    e = all_related(emails, "Emails")
    c = all_related(emergency_contacts, "Emergency Phone Contacts")
    o = all_related(other_infos, "Other Information")
    [p,e,a,c,o].find_all {|x| ! x.blank?}.join("<p></p>")
  end

  def role_val(role)
    case role
      when "Bd" : -500
      when "OL" : -250
      when "TM" : -100
      when "FM" : -50
      when "T"  : -25
      when "R"  : -10
      when "A"  : -5
      when "S"  : -1
      else 0
    end
  end

  def self.autoselect_member_names(suffix = "", path = "/members/")
    order('last_name ASC').all.map do |m|
      "{label: '#{m.full_name}', url: '#{path}#{m.id}#{suffix}'}"
    end.join(',')
  end

  def next_member
    list = Member.order('last_name ASC').all
    indx = list.index(self) + 1
    indx = 0 if indx == list.length
    list[indx]
  end

  def next_member_id
    next_member.id
  end

  def prev_member
    list = Member.order('last_name ASC').all
    indx = list.index(self)-1
    list[indx]
  end

  def prev_member_id
    prev_member.id
  end

  # ----- For Error Reporting -----

  def other_errors(error_hash, strip_keys)
    local_errors = error_hash.clone
    strip_keys.flatten.each {|x| local_errors.delete(x) }
    local_errors
  end

  def top_priority_error(error_hash, priority_list)
    return {} if error_hash.empty?
    priority_list.each do |item|
      if item.is_a?(Array)
        result = item.reduce({}) { |a,v| a[v] = error_hash[v] if error_hash[v]; a }
        return result if result.length > 0
      else
        return {item => error_hash[item]} if error_hash[item]
      end
    end
    {}
  end

  def scrubbed_errors
    full_name_errors = [[:first_name, :last_name], :user_name, :full_name]
    phone_errors     = [:phones_number, :phones]
    address_errors   = [:"addresses.address", [:"addresses.zip", :"addresses.state"], :"addresses.full_address"]
    errs = errors.messages.clone
    full_name_err = top_priority_error(errs, full_name_errors)
    phone_err     = top_priority_error(errs, phone_errors)
    address_err   = top_priority_error(errs, address_errors)
    priority_errors = full_name_errors +
                      phone_errors +
                      address_errors
#    debugger
    other_errors(errs, priority_errors).merge(full_name_err).
                                        merge(phone_err).
                                        merge(address_err)
  end

  def cleanup_message(message)
    return "" if message.blank?
    message.gsub(/\,.*/,'')
  end

  def cleanup_attr(name)
    name.gsub("Phones", "Phone").
         gsub("Emails", "Email").
         gsub("Addresses", "Address").
         gsub("contacts number", "contact number")
  end

  def full_messages(hash = scrubbed_errors)
    hash.map { |attribute, message|
      if attribute == :base
        message
      else
        attr_name = attribute.to_s.gsub('.', '_').humanize
        attr_name = self.class.human_attribute_name(attribute, :default => attr_name)

        message = message.join(', ') if message.class == Array

        "#{cleanup_attr(attr_name)} #{cleanup_message(message)}"
      end
    }.reverse
  end


end


