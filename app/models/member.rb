class Member < ActiveRecord::Base

  has_secure_password

  include MemberExtension::Base

  # ----- Attributes -----

  # Setup accessible (or protected) attributes for your model
  attr_accessible :password, :password_confirmation, :remember_me
  attr_accessible :title, :first_name, :last_name, :user_name, :full_name
  attr_accessible :typ, :v9, :ham, :base_role, :dl
  attr_accessible :phones_attributes, :addresses_attributes
  attr_accessible :roles_attributes,  :emails_attributes
  attr_accessible :photos_attributes, :certs_attributes, :docs_attributes
  attr_accessible :avail_ops_attributes, :avail_dos_attributes
  attr_accessible :emergency_contacts_attributes
  attr_accessible :other_infos_attributes
  attr_accessible :remember_me_token
  attr_accessible :forgot_password_token, :forgot_password_expires_at
  attr_accessible :bd, :ol, :admin
  attr_accessible :photo_icon

  # ----- Associations -----
  has_many :addresses,          :order => 'position', :dependent => :destroy
  has_many :phones,             :order => 'position', :dependent => :destroy
  has_many :emails,             :order => 'position', :dependent => :destroy
  has_many :photos,             :order => 'position', :dependent => :destroy
  has_many :other_infos,        :order => 'position', :dependent => :destroy
  has_many :emergency_contacts, :order => 'position', :dependent => :destroy
  has_many :roles,              :dependent => :destroy
  has_many :certs,              :dependent => :destroy
  has_many :data_files
  has_many :avail_ops,          :order => 'start_on', :dependent => :destroy
  has_many :avail_dos,          :dependent => :destroy
  has_many :messages
  has_many :distributions,      :dependent => :destroy
  has_many :journals
  has_many :participants,       :dependent => :destroy
  has_many :periods, :through => :participants
  has_many :events, :through => :periods
  has_many :primary_do_assignments, :class_name => 'DoAssignment', :foreign_key => 'primary_id'
  has_many :backup_do_assignments,  :class_name => 'DoAssignment', :foreign_key => 'backup_id'
  has_many :notices, :through => :distributions, :source => :message
  has_many :chats
  has_many :browser_profiles,   :dependent => :destroy

  accepts_nested_attributes_for :addresses,  :allow_destroy => true, :reject_if => lambda {|p| Member.invalid_address?(p) }
  accepts_nested_attributes_for :phones,     :allow_destroy => true, :reject_if => lambda {|p| Member.invalid_params?(p, :number) }
  accepts_nested_attributes_for :emails,     :allow_destroy => true, :reject_if => lambda {|p| Member.invalid_params?(p, :address) }
  accepts_nested_attributes_for :roles,      :allow_destroy => true
  accepts_nested_attributes_for :certs,      :allow_destroy => true
  accepts_nested_attributes_for :photos,     :allow_destroy => true
  accepts_nested_attributes_for :data_files, :allow_destroy => true
  accepts_nested_attributes_for :avail_ops,  :allow_destroy => true, :reject_if => lambda {|p| p[:start_txt].try(:empty?) && p[:end_txt].try(:empty?)}
  accepts_nested_attributes_for :avail_dos,  :allow_destroy => true, :reject_if => lambda {|p| Member.invalid_params?(p, :typ) }
  accepts_nested_attributes_for :emergency_contacts, :allow_destroy => true, :reject_if => lambda {|p| Member.invalid_params?(p, [:name, :number])}
  accepts_nested_attributes_for :other_infos,        :allow_destroy => true
  accepts_nested_attributes_for :chats

  # ----- Validations -----
  validates_associated    :addresses,          :unless => :is_guest
  validates_associated    :phones,             :emails
  validates_associated    :emergency_contacts, :other_infos

  validates_presence_of   :first_name, :last_name, :user_name
  validates_format_of     :title,      :with => /^[A-Za-z\.]+$/, :allow_blank => true
  validates_format_of     :first_name, :with => /^[A-Za-z]+$/
  validates_format_of     :last_name,  :with => /^[A-Za-z\- ]+$/
  validates_format_of     :user_name,  :with => /^[a-z_\.\-]+$/
  validates_format_of     :password,   :with => /^[A-z0-9]*$/
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

  def is_guest
    typ == 'G' || typ == 'GA' || typ == "GN"
  end

  # ----- Callbacks -----
  before_save       :set_role_scores
  before_validation :check_first_name_for_title
  before_validation :set_username_and_name_fields
  before_validation :set_pwd,                  :on => :create
  before_validation :set_remember_me_token,    :if => :password_digest_changed?

  # ----- Scopes -----
  scope :order_by_last_name,     -> { order("last_name ASC")                                                }
  scope :order_by_do_role_score, -> { order(['current_do DESC', :role_score, :last_name])                   }
  scope :order_by_role_score,    -> { order([:role_score, :last_name])                                      }
  scope :order_by_do_typ_score,  -> { order(['current_do DESC', :typ_score, :last_name])                    }
  scope :order_by_typ_score,     -> { order([:typ_score, :last_name])                                       }
  scope :standard_order,         -> { order_by_role_score                                                   }
  scope :roles_order,            -> { order_by_role_score                                                   }
  scope :typ_order,              -> { order_by_typ_score                                                    }
  scope :with_photos,            -> { where("id     IN (SELECT member_id from photos)")                     }
  scope :without_photos,         -> { where("id NOT IN (SELECT member_id from photos)")                     }
  scope :active,                 -> { where("typ in ('T', 'FM', 'TM')")                                     }
  scope :registered,             -> { where("typ in ('T', 'FM', 'TM', 'R', 'S', 'A')")                      }
  scope :registered_last_name,   -> { where("typ in ('T', 'FM', 'TM', 'R', 'S', 'A')").order_by_last_name   }
  scope :inactive,               -> { where("typ in ('R', 'S', 'A')").standard_order                        }
  scope :member_alums,           where("typ in ('MA')").standard_order
  scope :member_no_contact,      -> { where("typ in ('MN')").standard_order                                 }
  scope :guests,                 where("typ in ('G')").standard_order
  scope :guest_alums,            -> { where("typ in ('GA')").standard_order                                 }
  scope :guest_no_contact,       -> { where("typ in ('GN')").standard_order                                 }
  scope :current_do,             -> { where(:current_do => true)   }

  def self.by_role(role)
    where(:typ => role)
  end

  def self.role_count(role)
    by_role(role).count
  end

  def self.by_last_name(last_name)
    where(last_name: last_name).all.try(:first)
  end

  # ----- Class Methods ----
  def self.set_do
    where(:current_do => true).all.each {|mem| mem.current_do = false ; mem.save}
    DoAssignment.non_current.has_backup.all.each do |doa|
      doa.update_attributes(:backup_id => nil)
    end
    ass = DoAssignment.current.first
    if x = ass.backup
      x.current_do = true ; x.save
    else
      x = ass.primary
      return if x.blank?
      x.current_do = true ; x.save
    end
  end

  # ----- Virtual Attributes (Accessors) -----

  def full_name_do
    do_text = current_do ? " (DO)" : ""
    unavail = current_status == "unavailable" ? " (Unavail)" : ""
    full_name + do_text + unavail
  end

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
      self.title      = str[0].try(:capitalize_all)
      self.first_name = str[1].try(:capitalize_all)
      self.last_name  = str.length > 1 ? str[2..-1].join(' ').try(:capitalize_all) : ""
    else
      self.title      = ""
      self.first_name = str[0].try(:capitalize)
      self.last_name  = str[1] ? str[1..-1].join(' ').try(:capitalize_all) : ""
    end
  end

  def wiki_name
    full_name.gsub(' ','.')
  end

  def monitor_name
    first = self.first_name[0..0].downcase
    last  = self.last_name[0..2].downcase
    first + last
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
      role = roles.bds.first
      role.destroy unless role.blank?
    end
  end

  def ol
    roles.all.find {|r| r.typ.downcase == "ol"} ? true : false
  end

  def ol=(val)
    debugger
    if val == "1" || val == true
      unless ol
        roles.create(:typ => "OL")
      end
    end
    if val == "0" || val == false
      return if roles.blank?
      role = roles.ols.first
      role.destroy unless role.blank?
    end
  end

  # ----- Virtual Attributes (Readers) -----

  def email(typ)
    emails.where(:typ => typ).first
  end

  def phone(typ)
    phones.where(:typ => typ).first
  end

  def address(typ)
    addresses.where(:typ => typ).first
  end

  def short_name
    first_initial = first_name[0..0]
    "#{first_initial}. #{last_name}"
  end

  def full_roles
    arr = ([typ] + roles.map {|r| r.typ})
    arr.delete_if {|x| %w(UL TRS TO XO WEB SEC REG RO OO).include? x}
    arr.sort{|x,y| role_val(x) <=> role_val(y)}.join(' ')
  end

  def calc_typ_score
    role_val(typ)
  end

  def calc_roles_score
    full_roles.split(' ').reduce(0) {|a,v| a + role_val(v.strip.chomp)}
  end

  def set_role_scores
    self.role_score = calc_roles_score
    self.typ_score  = calc_typ_score
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

  def export
    attributes.merge({
      :phones_attributes             => phones.map             {|p| p.export},
      :addresses_attributes          => addresses.map          {|p| p.export},
      :emails_attributes             => emails.map             {|p| p.export},
      :emergency_contacts_attributes => emergency_contacts.map {|p| p.export},
      :other_infos_attributes        => other_infos.map        {|p| p.export},
      :roles_attributes              => roles.map              {|p| p.export},
      :avail_ops_attributes          => avail_ops.map          {|p| p.export},
      :avail_dos_attributes          => avail_dos.map          {|p| p.export}
    }).to_json
  end

  def full_export
    attributes.merge({
      :phones_attributes             => phones.map             {|p| p.export},
      :addresses_attributes          => addresses.map          {|p| p.export},
      :emails_attributes             => emails.map             {|p| p.export},
      :emergency_contacts_attributes => emergency_contacts.map {|p| p.export},
      :other_infos_attributes        => other_infos.map        {|p| p.export},
      :photos_attributes             => photos.map             {|p| p.export},
      :certs_attributes              => certs.map              {|p| p.export},
      :docs_attributes               => docs.map               {|p| p.export},
      :roles_attributes              => roles.map              {|p| p.export},
      :avail_ops_attributes          => avail_ops.map          {|p| p.export},
      :avail_dos_attributes          => avail_dos.map          {|p| p.export}
    }).to_json
  end

  def photo_export
  end

  def cert_export
  end

  def doc_export
  end

  # ----- Instance Methods -----

  def clear_password
    self.password = ""
    self.password_confirmation = ""
  end

  def reset_forgot_password_token
    Time.zone = "Pacific Time (US & Canada)"
    self.forgot_password_token      = rand(36 ** 8).to_s(36)
    self.forgot_password_expires_at = Time.now + 30.minutes
    self.save
  end

  def clear_forgot_password_token
    self.forgot_password_token = nil
    self.forgot_password_expires_at = nil
    self.save
  end

  def self.invalid_address?(params)
    return false if params["is_guest"] == "true"
    tmp = params[:full_address]
    tmp && (tmp.empty? || tmp.include?('...'))
  end

  def self.invalid_params?(params, field)
    fields = field.is_a?(Array) ? field : [field]
    fields.any? {|x| params[x].blank? || params[x].include?('...')}
  end

  def set_remember_me_token
    self.remember_me_token = rand(36 ** 16).to_s(36)
  end

  def check_first_name_for_title
    return if self.first_name.blank?
    return unless self.first_name.include?('.') && self.first_name.include?(" ")
    self.title, self.first_name = self.first_name.split(' ',2)
  end

  def get_cert_color
    current_medical_and_cpr? ? "black" : "red"
  end

  def current_medical?
    #color = member.certs.where(:typ => self.typ).where("id <> #{self.id}").newest.try(:expire_color)
    #! certs.medical.blank? && certs.medical.first.current?
    ! certs.medical.blank? && certs.medical.order("expiration ASC").last.current?
  end

  def current_cpr?
    #! certs.cpr.blank? && certs.cpr.first.current?
    ! certs.cpr.blank? && certs.cpr.order("expiration ASC").last.current?
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
    if self.password.blank?
      self.password = "welcome"
      self.password_confirmation = "welcome"
    end
    set_remember_me_token
  end

  def new_names_from_username
    return ["",""] if user_name.blank?
    user_name.split('_').map {|n| n.capitalize_all }
  end

  def cleanup_user_names
    self.user_name  = self.user_name.downcase unless self.user_name.blank?
    self.first_name = self.first_name.capitalize unless self.first_name.blank?
    self.last_name  = self.last_name.capitalize_all unless self.last_name.blank?
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

  def photo_icon
    photos.length == 0 ? "" : photos.first.image.url(:icon)
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
      when "Bd"  then -2000   # board of directors
      when "OL"  then -1500   # operations leader
      when "TM"  then -1000   # technical member
      when "FM"  then -800    # field member
      when "T"   then -750    # trainee
      when "R"   then -500    # reserve
      when "S"   then -250    # support
      when "A"   then -100    # associate
      when "G"   then -50     # guest
      when "MA" then -25      # member alum
      when "GA" then -15      # guest alum
      when "MN" then -10      # member no-contact
      when "GN" then -5       # guest no-contact
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

# == Schema Information
#
# Table name: members
#
#  id                         :integer          not null, primary key
#  title                      :string(255)
#  first_name                 :string(255)
#  last_name                  :string(255)
#  user_name                  :string(255)
#  typ                        :string(255)
#  ham                        :string(255)
#  v9                         :string(255)
#  admin                      :boolean          default(FALSE)
#  developer                  :boolean          default(FALSE)
#  role_score                 :integer
#  typ_score                  :integer
#  password_digest            :string(255)
#  sign_in_count              :integer          default(0)
#  ip_address                 :string(255)
#  remember_me_token          :string(255)
#  forgot_password_token      :string(255)
#  forgot_password_expires_at :datetime
#  google_oauth_token         :string(255)
#  remember_created_at        :time
#  created_at                 :datetime
#  updated_at                 :datetime
#  current_do                 :boolean          default(FALSE)
#  last_sign_in_at            :datetime
#  dl                         :string(255)
#

