module BrowserstatsHelper

  def format_unknown(str)
    str.match(/unknown/) ? "unknown" : str
  end

end
