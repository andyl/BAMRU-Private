module ReportsHelper
  # ----- for BAMRU-roster.csv -----
  def quote(str)
    return nil if str.nil?
    '"' + str.gsub("\n",",") + '"'
  end

  def field_record(mem, type)
    case type
      when "organization"   : "BAMRU"
      when "roles"          : mem.full_roles
      when "full_name"      : mem.full_name
      when "mobile_phone"   : mem.phone("Mobile").try(:number)
      when "home_phone"     : mem.phone("Gome").try(:number)
      when "work_phone"     : mem.phone("Work").try(:number)
      when "home_address"   : quote mem.address("Home").try(:full_address)
      when "work_address"   : quote mem.address("Work").try(:full_address)
      when "other_address"  : quote mem.address("Other").try(:full_address)
      when "home_email"     : mem.email("Home").try(:address)
      when "personal_email" : mem.email("Personal").try(:address)
      when "work_email"     : mem.email("Work").try(:address)
      when "ham"            : mem.ham
      when "v9"             : mem.v9
    end
  end

  def csv_record(mem, fields)
    fields.map {|field| field_record(mem, field)}.join(',')
  end

  # ----- for BAMRU-names.pdf -----
  def download_link(array)
    link_to("Download", "/reports/#{array[2]}", :target => "_blank")
  end

  def gdocs_link(array)
    link_to("Gdocs", "/reports/gdocs/#{array[2]}", :target => "_blank")
  end

  def report_format(array)
    array[2].split('.').last.upcase
  end

  def report_description(array)
    array[3]
  end

  # ----- for BAMRU-roster.html -----
  def gmap_adr(adr)
    x = [adr.address1,adr.address2,adr.city,adr.state,adr.zip] - [""]
    x.join(', ').gsub(' ','+').sub('#','%23')
  end

  def gmap_url(address)
    "http://maps.google.com/maps?q=#{gmap_adr(address)}"
  end

  def gmap_link(member, typ)
    adr = member.address(typ)
    return "NA" if adr.nil?
    "<a href='#{gmap_url(adr)}' target='_blank'>#{adr.city}</a>"
  end
end
