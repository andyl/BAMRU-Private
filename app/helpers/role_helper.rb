module RoleHelper

  def role_link(role)
    member = Role.member_for(role)
    if member.nil?
      "TBD"
    else
      "<a href='/members/#{member.id}' target='_blank'>#{member.full_name}</a>"
    end
  end

end

