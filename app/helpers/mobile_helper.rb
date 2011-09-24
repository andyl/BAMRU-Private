module MobileHelper
  def page_name
    return "BAMRU Mobile" unless defined?(@page_name)
    "#{@page_name}"
  end
end