class Action < ActiveRecord::Base

  # ----- Callbacks -----

  before_validation :check_for_identical_start_finish
  before_validation :convert_tbd_to_tba
  before_validation :cleanup_non_county
  before_validation :save_signature_into_digest_field
  before_save       :remove_quotes
  after_destroy     :set_first_in_year_after_delete
  after_save        :set_first_in_year_after_save

  # ----- Validations -----

  msg = "duplicate record - identical title, location, start"
  validates_uniqueness_of :digest, :message => msg
  validates_presence_of   :kind, :title, :location, :start
  validates_format_of     :kind, :with => /^(meeting|training|event|non-county)$/

  validate :confirm_start_happens_before_finish

  # Confirms that start happens before finish
  def confirm_start_happens_before_finish
    return if self.finish.nil? || self.finish.blank?
    errors[:start] << "must happen before 'end'" if self.finish < self.start
  end

  # ----- Date Methods -----

  # Parse a date.  The date can either be a string in the format 'Jan-2001', or
  # it can be a Time object.
  def self.date_parse(date)
    date.class == String ? Time.parse(date) : date
  end

  # When you bring up a calendar page, it shows events from a range of dates.
  # The default start is set to '2.months.ago'.
  def self.default_start()
    2.months.ago
  end

  def self.default_end()        10.months.from_now; end
  def self.first_event(); x = Action.order('start').first; x.start unless x.nil? ; end
  def self.last_event();  x = Action.order('start').last;  x.start unless x.nil? ;  end
  def self.first_year();  x = Action.first_event; x.at_beginning_of_year unless x.nil?; end
  def self.last_year();   x = Action.last_event;  x.at_end_of_year unless x.nil?; end

  # Returns an array of dates that are used in select form on the calendar page.
  # Dates are in the format of ["Jan-2001", "Jan-2002", "Jan-2003"]
  # An 'extra_date' may be provided, which will be inserted into the range_array
  # in the correct sort order.
  def self.range_array(extra_date = nil)
    return nil if self.first_year.nil? || self.last_year.nil?
    xa = ((self.first_year + 10.days).to_date .. (self.last_year + 1.year).to_date).step(365).to_a.map{|x| x.to_time}
    xa << Action.date_parse(extra_date) unless extra_date.nil?
    xa.sort.map {|x| x.to_label }.uniq
  end

  # ----- Scopes -----

  # Returns all actions where :kind == "meeting"
  def self.meetings
    where(:kind => "meeting").order('start')
  end

  # Returns all actions where :kind == "event"
  def self.events
    where(:kind => "event").order('start')
  end
  
  def self.non_county() where(:kind => "non-county").order('start'); end
  def self.trainings()  where(:kind => "training").order('start'); end
  def self.after(date)  where('start >= ?', self.date_parse(date)); end
  def self.before(date) where('start <= ?', self.date_parse(date)); end
  def self.between(start, finish) after(start).before(finish); end
  def self.in_year(date, kind)
    between(date.at_beginning_of_year, date.at_end_of_year).where(:kind => kind)
  end

  # ----- Local Methods - Data Cleanup and Standardization -----

  # CSV input data sometimes comes in non-standard formats.
  # Some come in as "non-county", some as "non-county meetings"
  # This method just reduces all variants to "non-county"
  def cleanup_non_county
    self.kind = 'non-county' if self.kind[0..5] == "non-co"
  end

  # Convert double quotes to single quotes.
  # This is done to support CSV output.
  # (CSV output fields are wrapped in double quotes.)
  def remove_quotes
    self.title.gsub!(%q["],%q['])       unless self.title.nil?
    self.location.gsub!(%q["],%q['])    unless self.location.nil?
    self.leaders.gsub!(%q["],%q['])     unless self.leaders.nil?
    self.description.gsub!(%q["],%q[']) unless self.description.nil?
  end

  # This method changes 'tba, TBD, tbd' to 'TBA'
  # It also changes nil or blank value to 'TBA'
  def convert_tbd_to_tba
    self.location.gsub!(/[Tt][Bb][DdAa]/, "TBA")
    self.location = "TBA" if self.location.nil? || self.location.blank?
    unless self.kind == 'meeting'
      self.leaders.gsub!(/[Tt][Bb][DdAa]/,  "TBA")
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
  def generate_digest_from_signature
    Digest::MD5.hexdigest(signature_fields)
  end

  # The digest field is checked to ensure it is unique.
  # This eliminates the possibility of duplicate records.
  def save_signature_into_digest_field
    self.digest = generate_digest_from_signature
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
    events = Action.in_year(start, kind).order('start').all
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

  # This method is used for tests, to reset the database
  # after each test scenario.  Deleting records using this
  # method invokes all the validations.  You could also
  # use built-in method 'Action.delete_all' which runs faster
  # because it ignores validations.
  def self.delete_all_with_validation
    Action.all.each { |x| x.destroy }
  end

end
