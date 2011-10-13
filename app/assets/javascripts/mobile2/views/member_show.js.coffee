main_template = '''
  <b><%= first_name %> <%= last_name %></b> - <%= full_roles %>
  <%= this.phone_helper() %>
  <%= this.email_helper() %>
'''

class @MemberShowView extends Backbone.View
  initialize: ->
    @main_template  = _.template(main_template)
  header: (id) ->
    "<div id='#{id}' data-role='listview' data-inset='true' data-theme='c'>"
  divider: (label) ->
    "<li data-role='list-divider'>#{label}</li>"
  phone_helper: ->
    return "" unless @model.hasPhone
    display = _(@model.attributes.phones_attributes).map (phone) ->
      num  = phone.number
      typ  = phone.typ
      val1 = "<a href='tel:#{num}'>#{num} - #{typ}</a>"
      val2 = if typ == "Mobile" then "<a href='sms:#{num}'></a>" else ""
      if is_phone == "true"
        "<li>#{val1}#{val2}</li>"
      else
        "<li>#{num} - #{typ}</li>"
    @header("phone_list") + @divider("Phones") + display.join('') + "</div>"
  email_helper: ->
    return "" unless @model.hasEmail
    display = "<li>email value</li>"
    display = _(@model.attributes.emails_attributes).map (email) ->
      adr  = email.address
      val1 = "<a href='mailto:#{adr}'>#{adr}</a>"
      "<li>#{val1}</li>"
    @header("email_list") + @divider("Emails") + display.join('') + "</div>"
  generate_page_elements: ->
    $('#phone_list').listview() if @model.hasPhone
    $('#email_list').listview() if @model.hasEmail
  render: =>
    $(@el).html(@main_template(@model.toJSON()))
    @