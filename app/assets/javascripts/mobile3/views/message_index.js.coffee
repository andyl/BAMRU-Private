#= require mobile3/views/common_view

message_index_template = '''
<a class="msglink" data-msgid="<%= id %>" href="#message">
#<%= id %> <%= creation_date %> from <%= author_short_name %>
<p class='ui-li-desc' style='margin-top: 3px;'>
<%= this.text_helper() %>
<%= this.rsvp_helper() %>
</p>
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
  text_helper: ->
    "#{@sent_read_helper()} #{@model.attributes.text}"
  yes_no_helper: ->
    yes_count = @model.rsvpYesCount()
    no_count  = @model.rsvpNoCount()
    @blue_wrap("Y#{yes_count} N#{no_count}")
  rsvp_helper: ->
    return "" unless @model.hasRSVP()
    return "<br/>#{@yes_no_helper()} #{@model.attributes.rsvp_prompt}"
  render: =>
    $(@el).html(@template(@model.toJSON()))
    @
