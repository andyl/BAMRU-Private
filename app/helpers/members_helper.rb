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

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, h("add_fields(this, '#{association}', '#{escape_javascript(fields)}')"))
#    link_to_function(name, h("add_fields(this, '#{association}', '#{fields}')"))
  end

end
