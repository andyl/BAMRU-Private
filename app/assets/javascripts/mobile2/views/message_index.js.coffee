#= require ./common_view

message_index_template = '''
<a href="#message?id=<%=id%>">
#<%= id %> <%= creation_date %> from <%= author_short_name %>
<p class='ui-li-desc' style='margin-top: 3px;'>
<%= this.text_helper() %>
<%= this.rsvp_helper() %>
</p>
</a>
'''

class @MessageIndexView extends CommonView
  tagName:    "li"
  initialize: ->
    @template = _.template(message_index_template)
  sent_read_helper: ->
    sent = @model.attributes.sent_count
    read = @model.attributes.read_count
    @blue_wrap("S#{sent} R#{read}")
  text_helper: ->
    "#{@sent_read_helper()} #{@model.attributes.text}"
  yes_no_helper: ->
    yes_count = @model.attributes.rsvp_yes_count
    no_count  = @model.attributes.rsvp_no_count
    @blue_wrap("Y#{yes_count} N#{no_count}")
  rsvp_helper: ->
    return "" unless @model.hasRSVP()
    return "<br/>#{@yes_no_helper()} #{@model.attributes.rsvp_prompt}"
  render: =>
    $(@el).html(@template(@model.toJSON()))
    @
