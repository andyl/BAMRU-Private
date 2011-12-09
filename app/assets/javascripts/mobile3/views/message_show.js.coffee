main_template = '''
<b>#<%= id %> <%= creation_date %> from <%= this.author_short_name() %></b><br/>
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
  author_short_name: ->
    window.auth = @model.author()
    return "" if auth == null
    auth.shortName()
  text_helper: ->
    "#{@model.attributes.text} #{@sent_read_helper()}"
  yes_no_helper: ->
    yes_count = @model.rsvpYesCount()
    no_count  = @model.rsvpNoCount()
    @blue_wrap("(Yes #{yes_count} / No #{no_count})")
  rsvp_helper: ->
    return "" unless @model.hasRSVP()
    return "<br/>RSVP: #{@model.attributes.rsvp_prompt} #{@yes_no_helper()} "
  read_helper: (dist) ->
    read = dist.get('read')
    return "Yes" if read == true
    "No"
  rsvp_helper2: (dist) ->
    return "Yes" if dist.get('rsvp_answer') == "Yes"
    return "No" if dist.get('rsvp_answer')  == "No"
    "NA"
  distribution_helper: ->
    me   = @
    rows = _(@model.distributions().models).map (dist) ->
      "<tr><td>#{dist.member().shortName()}</td><td>#{me.read_helper(dist)}</td><td>#{me.rsvp_helper2(dist)}</td></tr>"
    rows.join('')
  render: =>
    @model.markAsRead()
    $(@el).html(@template(@model.toJSON()))
    @
