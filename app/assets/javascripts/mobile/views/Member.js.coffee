main_template = '''
  <%= this.photo_helper() %>
  <b><%= first_name %> <%= last_name %></b> - <%= full_roles %>
  <%= this.phone_helper() %>
  <%= this.email_helper() %>
  <%= this.emergency_helper() %>
'''

class BB.Models.Member extends Backbone.Marionette.ItemView
  initialize: (memberId) ->
    @model = BB.Collections.members.get(memberId)
    @main_template  = _.template(main_template)

  tagName: "div"

  className: "member_detail"

  header: (id) ->
    "<div class='header' id='#{id}'>"

  divider: (label) ->
    "<div class='divider'>#{label}</div>"

  phone_helper: ->
    return "" unless @model.hasPhone()
    display = _(@model.attributes.phones_attributes).map (phone) ->
      num  = phone.number
      typ  = phone.typ
      unless window.isPhone()
        return "<div class=data>#{num} - #{typ}</div>"
      unless typ == "Mobile"
        return "<a class=nav href='tel:#{num}'>#{num} - #{typ}</a>"
      val1 = "<a class='lnav' href='tel:#{num}'>#{num} - #{typ}</a>"
      val2 = "<a class='rnav' href='sms:#{num}'>SMS</a>"
      "<div class=navbox>#{val1}#{val2}</div>"
    @divider("Phones") + display.join('')
  photo_helper: ->
    return "" unless @model.hasPhoto()
    "<img src='/assets/s.gif' class='#{@model.attributes.last_name.toLowerCase()} photo_icon'></img>"
  email_helper: ->
    return "" unless @model.hasEmail()
    display = _(@model.attributes.emails_attributes).map (email) ->
      adr  = email.address
      val1 = "<a class=nav href='mailto:#{adr}'>#{adr}</a>"
      "#{val1}"
    @divider("Emails") + display.join('')
  emergency_helper: ->
    return "" unless @model.hasContact()
    display = _(@model.attributes.contacts_attributes).map (emc) ->
      nam = emc.name
      typ = emc.typ
      num = emc.number
      dst = "#{nam} #{num} - #{typ}"
      unless window.isPhone()
        return "<div class=data>#{dst}</div>"
      unless typ == "Mobile"
        return "<a class=nav href='tel:#{num}'>#{dst}</a>"
      val1 = "<a class='lnav' href='tel:#{num}'>#{dst}</a>"
      val2 = "<a class='rnav' href='sms:#{num}'>SMS</a>"
      "<div class=navbox>#{val1}#{val2}</div>"
    @divider("Emergency Contacts") + display.join('')
  render: =>
    $(@el).html(@main_template(@model.toJSON()))
    @