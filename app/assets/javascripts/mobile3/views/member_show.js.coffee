main_template = '''
  <b><%= first_name %> <%= last_name %></b> - <%= full_roles %>
  <%= this.phone_helper() %>
  <%= this.email_helper() %>
'''

class @M3_MemberShowView extends Backbone.View
  initialize: ->
    @main_template  = _.template(main_template)
  tagName: "div"
  className: "member_detail"
  header: (id) ->
    "<div class='header' id='#{id}'>"
  divider: (label) ->
    "<div class='divider'>#{label}</div>"
  phone_helper: ->
    return "" unless @model.hasPhone
    display = _(@model.attributes.phones_attributes).map (phone) ->
      num  = phone.number
      typ  = phone.typ
      val1 = "<a href='tel:#{num}'>#{num} - #{typ}</a>"
      val2 = if typ == "Mobile" then "<a class=sms href='sms:#{num}'>SMS</a>" else ""
      if window.isPhone()
        "<div class=data>#{val1}#{val2}</div>"
      else
        "<div class=data>#{num} - #{typ}</div>"
    @divider("Phones") + display.join('')
  email_helper: ->
    return "" unless @model.hasEmail
    display = "<li>email value</li>"
    display = _(@model.attributes.emails_attributes).map (email) ->
      adr  = email.address
      val1 = "<a href='mailto:#{adr}'>#{adr}</a>"
      "<div class=data>#{val1}</div>"
    @divider("Emails") + display.join('')
  render: =>
    $(@el).html(@main_template(@model.toJSON()))
    @