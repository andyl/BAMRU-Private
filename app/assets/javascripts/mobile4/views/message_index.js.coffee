#= require mobile3/views/common_view

message_index_template = '''
<a class="nav" href="#messages/<%= id %>">
#<%= id %> <%= creation_date %> from <%= author_short_name %>
<%= this.text_helper() %>
<%= this.rsvp_helper() %>
</a>
'''

class @M4_MessageIndexView extends M4_CommonView
  tagName:    "li"
  initialize: ->
    @template = _.template(message_index_template)
  sent_read_helper: ->
    sent = @model.sentCount()
    read = @model.readCount()
    @blue_wrap("S#{sent} R#{read}")
  text_helper: ->
    "<br/>#{@sent_read_helper()} #{@model.attributes.text}"
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
