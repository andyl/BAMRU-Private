require 'spec_helper'

describe CsvLoader do

  before(:all) { generate_valid_test_data; generate_test_data_with_errors }

  describe "attributes" do
    subject { CsvLoader.new("no-op") }
    it { should respond_to(:input_filename) }
    it { should respond_to(:malformed_filename) }
    it { should respond_to(:invalid_filename) }
    it { should respond_to(:input_text) }
    it { should respond_to(:num_input) }
    it { should respond_to(:num_successful) }
    it { should respond_to(:num_malformed) }
    it { should respond_to(:num_invalid) }
  end

  describe "public methods" do
    subject { CsvLoader.new("no-op") }
    it { should respond_to(:input_file_exists?) }
    it { should respond_to(:has_errors?) }
    it { should respond_to(:read_and_process_csv_data) }
    it { should respond_to(:error_message) }
    it { should respond_to(:success_message) }
  end

  describe ".new" do
    context "when no file_name is specified" do
      it "raises an exception" do
        expect { CsvLoader.new }.to raise_error
      end
    end

    context "when using an input file_name" do
      it "returns a valid object" do
        CsvLoader.new(TEST_FILE_VALID).should_not be_nil
      end
    end
  end

  describe "#input_filename" do
    it "uses the init parameter as the input file name" do
      x = CsvLoader.new(TEST_FILE_VALID)
      x.input_filename.should == TEST_FILE_VALID
    end
  end

  describe "#input_file_exists?" do
    context "when using an existing file" do
      it "returns true" do
        x = CsvLoader.new(TEST_FILE_VALID)
        x.input_file_exists?.should == true
      end
    end
    context "when using a non-existing file" do
      it "returns false" do
        x = CsvLoader.new('/non-existing/file')
        x.input_file_exists?.should == false
      end
    end
  end

  describe "#num_input" do
    context "when loading valid data" do
      it "reports the correct number of input records" do
        CsvLoader.new(TEST_FILE_VALID).num_input.should == NUM_INPUT
      end
    end
    context "when loading data with errors" do
      it "reports the correct number of input records" do
        CsvLoader.new(TEST_FILE_ERRORS).num_input.should == NUM_INPUT
      end
    end
  end

  describe "#num_successful" do
    context "when loading valid data" do
      it "reports the correct number of successful records" do
        CsvLoader.new(TEST_FILE_VALID).num_successful.should == NUM_INPUT
      end
    end
    context "when loading data with errors" do
      it "reports the correct number of successful records" do
        success = NUM_INPUT - NUM_INVALID - NUM_MALFORMED
        CsvLoader.new(TEST_FILE_ERRORS).num_successful.should == success
      end
    end
    context "when re-loading identical data" do
      it "reports zero successful records" do
        CsvLoader.new(TEST_FILE_VALID)
        CsvLoader.new(TEST_FILE_VALID).num_successful.should == 0
      end
    end
    context "when there is existing data, and loading new data" do
      it "reports the correct number of new records" do
        success = NUM_INPUT - NUM_INVALID - NUM_MALFORMED
        CsvLoader.new(TEST_FILE_VALID)
        CsvLoader.new(TEST_FILE_ERRORS).num_successful.should == success
      end
      it "reports the correct number of total records" do
        total_records = NUM_INPUT - NUM_INVALID - NUM_MALFORMED + NUM_INPUT
        CsvLoader.new(TEST_FILE_VALID)
        CsvLoader.new(TEST_FILE_ERRORS)
        Action.count.should == total_records
      end
    end

  end

  describe "#num_invalid" do
    context "when loading valid data" do
      it "reports no invalid records" do
        CsvLoader.new(TEST_FILE_VALID).num_invalid.should == 0
      end
    end
    context "when loading data with errors" do
      it "reports the correct number of invalid records" do
        CsvLoader.new(TEST_FILE_ERRORS).num_invalid.should == NUM_INVALID
      end
    end
    context "when re-loading identical data" do
      it "reports that all records are invalid (duplicate)" do
        CsvLoader.new(TEST_FILE_VALID)
        CsvLoader.new(TEST_FILE_VALID).num_invalid.should == NUM_INPUT
      end
    end
  end

  describe "#num_malformed" do
    context "when loading valid data" do
      it "reports zero malformed records" do
        CsvLoader.new(TEST_FILE_VALID).num_malformed.should == 0
      end
    end
    context "when loading data with errors" do
      it "reports the correct number of malformed records" do
        CsvLoader.new(TEST_FILE_ERRORS).num_malformed.should == NUM_MALFORMED
      end
    end
    context "when re-loading data with errors" do
      it "reports the correct number  of malformed records" do
        CsvLoader.new(TEST_FILE_ERRORS)
        CsvLoader.new(TEST_FILE_ERRORS).num_malformed.should == NUM_MALFORMED
      end
    end
  end

  describe "#malformed_filename" do
    it "returns a filename" do
      CsvLoader.new(TEST_FILE_ERRORS).malformed_filename.should_not be_nil
    end
  end

  describe "#invalid_filename" do
    it "returns a filename" do
      CsvLoader.new(TEST_FILE_ERRORS).invalid_filename.should_not be_nil
    end
  end

  describe "#has_errors?" do
    context "when loading valid data" do
      it "returns false" do
        CsvLoader.new(TEST_FILE_VALID).has_errors?.should == false
      end
    end
    context "when loading data with errors" do
      it "returns true" do
        CsvLoader.new(TEST_FILE_ERRORS).has_errors?.should == true
      end
    end
  end

  describe "#error_message" do
    context "when loading valid data" do
      it "generates an empty error message" do
        x = CsvLoader.new(TEST_FILE_VALID)
        x.error_message.should_not be_nil
        x.error_message.should be_empty
      end
    end
    context "when loading data with errors" do
      it "generates a non-empty error message" do
        x = CsvLoader.new(TEST_FILE_ERRORS)
        x.error_message.should_not be_nil
        x.error_message.should_not be_empty
      end
    end
  end

  describe "#success_message" do
    context "when loading valid data" do
      it "generates a success message" do
        CsvLoader.new(TEST_FILE_VALID).success_message.should_not be_empty
      end
    end
    context "when loading data with errors" do
      it "generates a success message" do
        CsvLoader.new(TEST_FILE_ERRORS).success_message.should_not be_empty
      end
    end
  end

end
