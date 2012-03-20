require_relative "../../../app/extensions/message_extension/klass"

class TestKlass
  extend MessageExtension::Klass
end

describe MessageExtension::Klass do

  describe "class methods" do

    specify { TestKlass.should respond_to :devices                     }
    specify { TestKlass.should respond_to :distributions_params        }
    specify { TestKlass.should respond_to :mobile_distributions_params }

  end

end