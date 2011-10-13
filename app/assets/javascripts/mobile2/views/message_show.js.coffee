main_template = '''
<b>#<%= id %> <%= creation_date %> from <%= author_short_name %></b><br/>
<%= this.text_helper() %>
<%= this.rsvp_helper() %>
<hr>
<table width=100%>
<thead>
<tr>
<th scope="col" align=left>Recipient</th>
<th scope="col" align=left>Read?    </th>
<th scope="col" align=left>RSVP     </th>
</thead>
<tbody>
<%= this.distribution_helper() %>
</tbody>
</table>
'''

class @MessageShowView extends CommonView
  initialize: ->
    @template = _.template(main_template)
  sent_read_helper: ->
    sent = @model.attributes.sent_count
    read = @model.attributes.read_count
    @blue_wrap("(Sent #{sent} / Read #{read})")
  text_helper: ->
    "#{@model.attributes.text} #{@sent_read_helper()}"
  yes_no_helper: ->
    yes_count = @model.attributes.rsvp_yes_count
    no_count  = @model.attributes.rsvp_no_count
    @blue_wrap("(Yes #{yes_count} / No #{no_count})")
  rsvp_helper: ->
    return "" unless @model.hasRSVP()
    return "<br/>RSVP: #{@model.attributes.rsvp_prompt} #{@yes_no_helper()} "
  distribution_helper: ->
    rows = _(@model.attributes.distributions).map (dist) ->
      "<tr><td>#{dist.name}</td><td>#{dist.read}</td><td>#{dist.rsvp}</td></tr>"
    rows.join('')
  render: =>
    $(@el).html(@template(@model.toJSON()))
    @
