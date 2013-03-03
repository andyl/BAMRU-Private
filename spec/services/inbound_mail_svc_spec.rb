require 'spec_helper'

describe InboundMailSvc do

  describe "Object Attributes" do
    before(:all) { @obj = InboundMailSvc.new }
    #specify { @obj.should respond_to(:message) }
    #specify { @obj.should respond_to(:members) }
    #specify { @obj.should respond_to(:params)  }
  end

  describe "Instance Methods" do
    before(:all) { @obj = InboundMailSvc.new }
    specify { @obj.should respond_to(:load_inbound)      }
    specify { @obj.should respond_to(:create_from_mail)  }
    specify { @obj.should respond_to(:create_from_opts)  }
  end

  def gen_mail(arg = {})
    standard_args = {
        :to      => 'reciever@gmail.com',
        :from    => 'sender@gmail.com',
        :subject => 'test subject',
        :body    => 'sample body'
    }
    tgt_args = if arg.class == String
                 standard_args.merge({:body => arg})
               else
                 standard_args.merge(arg)
               end
    InboundMailSvc.new.create_from_mail(Mail.new(tgt_args))
  end

  describe "#gen_mail" do
    specify { gen_mail.should_not be_nil              }
    specify { gen_mail.class.should == InboundMail    }
    it "handles attribute over-ride" do
      btxt = "Hello World"
      @obj = gen_mail({:body => btxt})
      @obj.body.should == btxt
    end
  end

  describe ".create_from_mail" do
    specify { gen_mail("yes this is great").rsvp_answer.should   == "Yes"}
    specify { gen_mail("y this is great").rsvp_answer.should     == "Yes"}
    specify { gen_mail("this yes is great").rsvp_answer.should   == "Yes"}
    specify { gen_mail("this yea is great").rsvp_answer.should   == "Yes"}
    specify { gen_mail("this y is great").rsvp_answer.should     == "Yes"}
    specify { gen_mail("this n is great").rsvp_answer.should     == "No" }
    specify { gen_mail("this nO is great").rsvp_answer.should    == "No" }
    specify { gen_mail("this is great").rsvp_answer.should       == nil  }
    specify { gen_mail("this is great").rsvp_answer.should       == nil  }
  end



  #describe "#default_message" do
  #  before(:each) do
  #    @obj = PageGenSvc.new
  #    @evn = double()
  #    @per = double()
  #    @evn.stub(:title).and_return("HI")
  #    @per.stub(:position).and_return(1)
  #    @obj.stub(:current_event).and_return(@evn)
  #    @obj.stub(:current_period).and_return(@per)
  #  end
  #  it "works with no format" do
  #    @obj.default_message.should == ""
  #  end
  #  it "works with (info|broadcast|invite|leave|return)" do
  #    %w(info broadcast invite leave return).each do |format|
  #      @obj.format = format
  #      @obj.default_message.length.should > 2
  #    end
  #  end
  #end

end
