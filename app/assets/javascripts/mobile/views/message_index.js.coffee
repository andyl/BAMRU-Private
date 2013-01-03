#= require mobile/views/common_view

message_index_template = '''
<a class="nav" href="#messages/<%= id %>">
#<%= id %> <%= creation_date %> from <%= this.author_short_name() %>
<%= this.text_helper() %>
<%= this.rsvp_helper() %>
</a>
'''

class @M3_MessageIndexView extends M3_CommonView
  tagName:    "li"
  initialize: ->
    @template = _.template(message_index_template)
  sent_read_helper: ->
    sent = @model.sentCount()
    read = @model.readCount()
    @blue_wrap("S#{sent} R#{read}")
  author_short_name: ->
    window.auth = @model.author()
    return "" if auth == null
    auth.shortName()
  text_helper: ->
    "<br/>#{@sent_read_helper()} #{@model.get('text')}"
  yes_no_helper: ->
    yes_count = @model.rsvpYesCount()
    no_count  = @model.rsvpNoCount()
    @blue_wrap("Y#{yes_count} N#{no_count}")
  rsvp_helper: ->
    return "" unless @model.hasRSVP()
    "<br/>#{@yes_no_helper()} #{@model.attributes.rsvp_prompt}"
  render: =>
    $(@el).html(@template(@model.toJSON()))
    @
