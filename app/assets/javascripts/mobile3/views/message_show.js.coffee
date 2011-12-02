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

class @M3_MessageShowView extends M3_CommonView
  initialize: ->
    @template = _.template(main_template)
  sent_read_helper: ->
    sent = @model.sentCount()
    read = @model.readCount()
    @blue_wrap("(Sent #{sent} / Read #{read})")
  text_helper: ->
    "#{@model.attributes.text} #{@sent_read_helper()}"
  yes_no_helper: ->
    yes_count = @model.rsvpYesCount()
    no_count  = @model.rsvpNoCount()
    @blue_wrap("(Yes #{yes_count} / No #{no_count})")
  rsvp_helper: ->
    return "" unless @model.hasRSVP()
    return "<br/>RSVP: #{@model.attributes.rsvp_prompt} #{@yes_no_helper()} "
  distribution_helper: ->
    window.what = @model.distributions
    rows = _(@model.distributions.models).map (dist) ->
      "<tr><td>#{dist.get('name')}</td><td>#{dist.get('read')}</td><td>#{dist.get('rsvp')}</td></tr>"
    rows.join('')
  render: =>
    @model.markAsRead()
    $(@el).html(@template(@model.toJSON()))
    @
