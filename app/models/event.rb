class Event < ActiveRecord::Base

  # ----- Attributes -----

  attr_accessible :title, :typ, :start, :finish, :location, :lat, :lon, :leaders
  attr_accessible :all_day, :published, :description

  # ----- API -----

  def as_json(options = {})
    {
        id:       self.id,
        title:    self.title,
        typ:      self.typ,
        start:    self.start.try(:strftime, "%Y-%m-%d %H:%M"),
        finish:   self.finish.try(:strftime, "%Y-%m-%d %H:%M"),
        location: self.location,
        leaders:  self.leaders,
        lat:      self.lat,
        lon:      self.lon,
        all_day:  self.all_day,
        published:   self.published,
        description: self.description
    }
  end


  # ----- Associations -----

  belongs_to :leader,       :class_name => 'Member'
  has_many   :periods,      :dependent => :destroy
  has_many   :event_links,  :dependent => :destroy
  has_many   :event_photos, :dependent => :destroy
  has_many   :data_files,   :dependent => :destroy

  # ----- Callbacks -----

  #before_validation :check_for_identical_start_finish
  #before_validation :convert_tbd_to_tba
  #before_validation :save_signature_into_digest_field
  #before_validation :cleanup_lat_lon_fields
  #before_save       :remove_quotes
  #before_save       :truncate_coordinates
  #after_destroy     :set_first_in_year_after_delete
  #after_save        :set_first_in_year_after_save

  # ----- Validations -----
  validates_presence_of :typ, :title, :start
  validates_format_of   :typ, :with => /^(training)|(operation)|(meeting)|(social)|(community)$/

  validate :lat_lon

  def lat_lon
    return if self.lat.nil? && self.lon.nil?
    return if ! self.lat.nil? && ! self.lon.nil?
    errors.add :base, "Cannot have just one lat/lon field"
  end

  msg = "duplicate record - identical title, location, start"
  #validates_uniqueness_of :digest, :message => msg
  validates_presence_of   :typ, :title, :location, :start

  validates_numericality_of :lat, :allow_nil => true, :greater_than => 30,   :less_than => 43
  validates_numericality_of :lon, :allow_nil => true, :greater_than => -126, :less_than => -113

  #validate :confirm_start_happens_before_finish

  def confirm_start_happens_before_finish
    return if self.finish.nil? || self.finish.blank?
    errors[:start] << "must happen before 'end'" if self.finish < self.start
  end

  # ----- Scopes -----
  scope :operations,    where(typ: "operation").order('start')
  scope :trainings,     where(typ: "training").order('start')
  scope :meetings,      where(typ: "meeting").order('start')
  scope :communities,   where(typ: "community").order('start')
  scope :socials,       where(typ: "social").order('start')

  def self.kind(typ)    where(:typ => typ).order('start');           end
  def self.after(date)  where('start >= ?', self.date_parse(date));  end
  def self.before(date) where('start <= ?', self.date_parse(date));  end
  def self.between(start, finish) after(start).before(finish);       end
  def self.in_year(date)
    between(date.at_beginning_of_year, date.at_end_of_year)
  end
  
  # ----- Class Methods - Generic Date Methods -----

  # Parse a date.  The date can either be a string in the format 'Jan-2001', or
  # it can be a Time object.
  def self.date_parse(date)
    date.class == String ? Time.parse(date) : date
  end

  def self.default_start() 6.weeks.ago;        end
  def self.default_end()   1.year.from_now;    end
  def self.default_start_operation() 24.months.ago;    end
  def self.default_end_operation()   1.month.from_now; end

  # Any of these methods may be used with a scope.
  #   Event.first_event            - first event of all Events
  #   Event.operations.first_event - first event of operations Events
  def self.first_event(); x = where("").order('start').first; x.start unless x.nil? ; end
  def self.last_event();  x = where("").order('start').last;  x.start unless x.nil? ;  end
  def self.first_year();  x = where("").first_event; x.at_beginning_of_year unless x.nil?; end
  def self.last_year();   x = where("").last_event;  x.at_end_of_year unless x.nil?; end

  # Returns an array of dates that are used in select form on the calendar page.
  # Dates are in the format of ["Jan-2001", "Jan-2002", "Jan-2003"]
  # An 'extra_date' may be provided, which will be inserted into the range_array
  # in the correct sort order.
  # This method may be used with a scope.
  #   Event.range_array             - generate a range_array over all Events
  #   Event.operations.range_array  - generage a range_array over 'operations'
  def self.range_array(extra_date = nil)
    scope = where("")
    return nil if scope.first_year.nil? || scope.last_year.nil?
    xa = ((scope.first_year + 10.days).to_date .. (scope.last_year + 1.year).to_date).step(365).to_a.map{|x| x.to_time}
    xa << Event.date_parse(extra_date) unless extra_date.nil?
    xa.sort.map {|x| x.to_label }.uniq
  end

  # ----- Local Methods - iCal Date Methods -----
  def dt_start
    date = start.strftime("%Y%m%d")
    typ == "meeting" ? date + "T193000" : date
  end

  def dt_end
    date = (finish.nil? || finish.blank?) ? start.strftime("%Y%m%d") : finish.strftime("%Y%m%d")
    typ == "meeting" ? date + "T213000" : date
  end

  def dt_stamp
    updated_at.strftime("%Y%m%dT%H%M%S")
  end

  # ----- Local Methods - gCal Date Methods -----
  def gcal_start
    typ == "meeting" ? start.to_time.change(:hour => 19, :min => 30) : start.to_time
  end

  def gcal_finish
    if typ == "meeting"
      start.to_time.change(:hour => 21, :min => 30)
    else
      (finish.nil? || finish.blank?) ?
              start.to_time :
              (finish + 1.day).to_time
    end
  end

  def gcal_all_day?
    typ == "meeting" ? false : true
  end

  def gcal_content
    lead = leaders.nil? || leaders.blank? ? "" : "[Leaders: #{leaders}] "
    body = lead + description
    break_str = (body.nil? || body.blank?) ? "" : "\n\n"
    sig = "(BE#{id} - #{digest_signature})"
    body + break_str + sig
  end

  def gcal_location
    rwc = "455 County Center Room 101, Redwood City, CA 94063"
    cav = "17930 Lake Chabot Road, Castro Valley, CA 94546"
    return location unless typ == "meeting"
    case location.strip.chomp
      when "Redwood City"  then rwc
      when "Castro Valley" then cav
      else location
    end
  end

  # ----- Local Methods - Data Cleanup and Standardization -----

  # Convert double quotes to single quotes.
  # This is done to support CSV output.
  # (CSV output fields are wrapped in double quotes.)
  def remove_quotes
    self.title.gsub!(%q["],%q['])       unless self.title.nil?
    self.location.gsub!(%q["],%q['])    unless self.location.nil?
    self.leaders.gsub!(%q["],%q['])     unless self.leaders.nil?
    self.description.gsub!(%q["],%q[']) unless self.description.nil?
  end

  def cleanup_lat_lon_fields
    self.lat = nil unless self.typ == 'operation'
    self.lon = nil unless self.typ == 'operation'
  end

  # Truncates coordinates to five digits
  def truncate_coordinates
    self.lat = (self.lat * 1000000).round / 1000000.0 unless self.lat.blank?
    self.lon = (self.lon * 1000000).round / 1000000.0 unless self.lon.blank?
  end

  # This method changes 'tba, TBD, tbd' to 'TBA'
  # It also changes nil or blank value to 'TBA'
  def convert_tbd_to_tba
    self.location.gsub!(/[Tt][Bb][DdAa]/, "TBA")
    self.location = "TBA" if self.location.nil? || self.location.blank?
    unless self.typ == 'meeting'
      self.leaders.gsub!(/[Tt][Bb][DdAa]/,  "TBA") unless self.leaders.nil?
      self.leaders = "TBA" if self.leaders.nil? || self.leaders.blank?
    end
  end

  # If the finish date is identical to the start date,
  # the finish date is set to 'nil'
  def check_for_identical_start_finish
    self.finish = nil if self.start == self.finish
  end

  # ----- Local Methods - Signature/Digest -----

  # These fields uniquely identify a record.
  def signature_fields
    "#{self.title}/#{self.location}/#{self.start}"
  end

  # The digest is a MD5 digest generated from the signature_fields.
  def digest_signature
    Digest::MD5.hexdigest(signature_fields)
  end

  # The digest field is checked to ensure it is unique.
  # This eliminates the possibility of duplicate records.
  def save_signature_into_digest_field
    self.digest = digest_signature
  end

  # ----- Local Methods - Data Display -----

  # Generates a formatted date. e.g.
  # Jan 23, 2001    - one-day event   - first_in_year == true
  # Jan 24-25, 2001 - multi-day event - first_in_year == false
  # Feb 24          - one-day event   - first_in_year == true
  # Feb 24-25       - multi-day event - first_in_year == false
  def date_display(show_year = false)
    year_string = first_in_year || show_year ? ", #{start.year}&nbsp;" : ""
    finish_string = finish ? "-#{finish.day}" : ""
    "#{start.strftime('%b')} #{start.day}#{finish_string}#{year_string}"
  end

  # ----- Local Methods - Year Formatting -----

  # In the calendar display list, we wanted to display the year
  # for the first event in the year, but not for the following events
  # in the year.
  #
  # There is a database field 'first_in_year'
  # The first event is a year is set to 'true'
  # Other events in the year are set to 'false'
  # The 'first_in_year' field is reset after records are added/modified/deleted.
  #
  # The 'first_in_year' field is used by the #date_display method to generate
  # formatted output for the calendar page.

  # This method resets the 'first_in_year' field for
  # all field relevant to 'self'
  def reset_first_in_year
    events = Event.typ(typ).in_year(start).order('start').all
    unless events.empty?  # this could happen if you delete a record...
      events.first.update_attributes(:first_in_year => true)
      events[1..-1].each { |x| x.update_attributes(:first_in_year => false) }
    end
  end

  # This method is called after a record is deleted.
  # No reset is done unless the record is the first in the year.
  def set_first_in_year_after_delete
    return unless self.first_in_year == true
    reset_first_in_year
  end

  # This method is called after a record is created or saved.
  # No reset is done unless the start field was changed.
  def set_first_in_year_after_save
    return unless self.start_changed?
    reset_first_in_year
  end

  # ----- Local Methods - Utility Methods ------

  def archive_url
    start.strftime("%Y_%m_01_archive.html")
  end

  def kml_description
    lbl = leaders.include?(",") ? "Leaders" : "Leader"
    ldr = leaders == "TBA" ? "" : "#{lbl}: #{leaders}<br/>"
    link = description.gsub("[","").gsub("]", "")
    mesg = "Find more information on the <a href='#{link}'>BAMRU Blog</a>"
    ldr + mesg
  end  
  
  
end


# == Schema Information
#
# Table name: events
#
#  id          :integer         not null, primary key
#  typ         :string(255)
#  title       :string(255)
#  leaders     :string(255)
#  description :text
#  location    :string(255)
#  lat         :decimal(7, 4)
#  lon         :decimal(7, 4)
#  start       :datetime
#  finish      :datetime
#  all_day     :boolean         default(TRUE)
#  published   :boolean         default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#

