module MembersHelper
  def phone_checkbox(member)
    list = member.phones.pagable
    if list.blank? 
      "<td></td>"
    else
      "<td class=checkbox><input class='rck #{member.full_roles}' name='distributions[#{member.id}_phone]' type='checkbox'></td>"
    end
  end

  def email_checkbox(member)
    list = member.emails.pagable
    if list.blank?
      "<td></td>"
    else
      "<td class=checkbox><input class='rck #{member.full_roles}' name='distributions[#{member.id}_email]' type='checkbox'></td>"
    end
  end

  def link_to_remove_field(name, f)
    link_to_function(name, "remove_fields(this);")
  end

  def link_to_add_fields(name, f, association, params={})
    new_object = f.object.class.reflect_on_association(association).klass.new(params)
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, h("add_fields(this, '#{association}', '#{escape_javascript(fields)}')"))
  end

  # ----- For Help Message -----

  def check_style(f)
    return nil if f.nil?
    return unless f.respond_to?(:non_standard_typ?)
    "background-color: lightyellow;" if f.non_standard_typ?
  end

  def has_non_standard_records(mem)
    mem.phones.where
  end

  def edit_info_message
    <<-ERB
      <div style='background-color: lightyellow; font-size: 10px; text-align: center;'>
        Please move highlighted records to "Emergency Contacts" or  "Other Info". (#{link_to("more", '/home/edit_info', :target => "_blank")})
      </div>
    ERB
  end

end
