require 'fastercsv'

class CsvLoader

  # ----- Class Attributes -----

  # The CSV filename that is passed when the object is initialized.
  attr_reader :input_filename

  # The file that stores the malformed CSV records.
  attr_reader :malformed_filename
  
  # The file that stores the invalid CSV records.
  attr_reader :invalid_filename

  # The text of the CSV input file.
  attr_reader :input_text

  # The number of input records processed.
  # Count includes just the CSV records - not the CSV header.
  attr_reader :num_input

  # The number of records that were successfully loaded into the database.
  attr_reader :num_successful

  # The number of records that contained malformed CSV data.
  attr_reader :num_malformed

  # The number of invalid records that were rejected by the validation rules.
  attr_reader :num_invalid

  # ----- Public Methods -----

  # Requires an input filename, with CSV data.
  # Loads valid CSV records into the database.
  def initialize(input_filename)
    @input_filename = input_filename
    @malformed_filename = MALFORMED_FILENAME
    @invalid_filename   = INVALID_FILENAME
    @input_text = ""
    @num_input = @num_successful = @num_malformed = @num_invalid = 0
    return unless input_file_exists?
    read_and_process_csv_data
  end

  # Returns true if the input file exists, otherwise false.
  def input_file_exists?
    File.exist? @input_filename
  end

  # Returns true if the input file has one or
  # more malformed or invalid records.
  def has_errors?
    @num_malformed != 0 || @num_invalid != 0
  end

  # Reads and processes CSV data
  # - reads input CSV data
  # - loads valid CSV records into the database
  # - stores malformed CSV records in @malformed_filename
  # - stores invalid CSV records in @invalid_filename
  def read_and_process_csv_data(input_file = @input_filename)
    setup_csv_loader_files_and_directories
    start_count = Action.count
    @input_text = File.read(input_file)
    csv_array = parse_csv_and_return_array(input_file)
    csv_array_to_hash(csv_array).each do |r|
      h = r.to_hash
      h["kind"].downcase! unless h["kind"].nil?
      record = Action.create(h)
      unless record.valid?
        @num_invalid += 1
        File.open(@invalid_filename, 'a') do |f|
          f.puts r; f.puts record.errors.inspect
        end
      end
    end
    finish_count = Action.count
    @num_successful = finish_count - start_count
  end

  # Generates an error message.
  def error_message
    msg = ""
    msg << csv_message(@num_malformed, 'malformed') if @num_malformed != 0
    msg << csv_message(@num_invalid, 'invalid') if @num_invalid != 0
    msg
  end

  # Generates a success message.
  def success_message
    "CSV File Upload created #{@num_successful} new records."
  end

  # ----- Private Methods -----

  private

  # Resets data files and directories.
  def setup_csv_loader_files_and_directories
    system "mkdir -p #{DATA_DIR}"
    system "rm -f #{@invalid_filename}"
    system "rm -f #{@malformed_filename}"
  end

  def csv_link(target)
    "(<a href='/#{target}_csv'>view</a>)"
  end

  def csv_message(number, target)
    " Warning! #{number} #{target} records. #{csv_link(target)} "
  end

  # Reads data from @marshall_filename, and parses each line, one by one.
  # Records which do not parse correctly are saved in @malformed_filename.
  def parse_csv_and_return_array(input_file)
    bad_csv = ""
    output = File.read(input_file).reduce([]) do |a,v|
      @num_input += 1
      begin
        a << v.parse_csv
      rescue
        @num_malformed += 1
        bad_csv << v
      end
      a
    end
    @num_input -= 1 if @num_input > 0
    unless bad_csv.empty?
      File.open(@malformed_filename, 'w') {|f| f.puts bad_csv}
    end
    output
  end

  # Converts an array of csv inputs to an array of hash.
  def csv_array_to_hash(data)
    headers = data.first
    fields  = data[1..-1]
    fields.reduce([]) do |a,v|
      a << FasterCSV::Row.new(headers, v)
      a
    end
  end

end

