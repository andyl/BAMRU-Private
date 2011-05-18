class String
  def br
    self.blank? ? "" : self + "<br/>"
  end
end


class Address < ActiveRecord::Base

  # ----- Associations -----

  belongs_to :user


  # ----- Callbacks -----



  # ----- Validations -----



  # ----- Scopes -----



  # ----- Local Methods-----

  def output
    <<-EOF.gsub('      ','')
      #{address1.br}#{address2.br}
      #{city} #{state} #{zip} (#{typ})
    EOF
  end


end
