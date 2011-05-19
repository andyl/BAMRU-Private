class Cert < ActiveRecord::Base
  has_attached_file :document,
                    :styles => {:medium => "300x300>", :thumb => "100x100>" }

end
