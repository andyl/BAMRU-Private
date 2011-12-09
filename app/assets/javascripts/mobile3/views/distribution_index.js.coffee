
window.distribution_index_template = '''
<a class=nav href="#messages/<%= message_id %>"><%= this.readYesNoHelper() %><%= message_id %> - <%= this.gText() %></a>
'''

class @M3_DistributionIndexView extends M3_CommonView
  tagName:    "li"
  initialize: ->
    @template = _.template(distribution_index_template)
  gText: ->
    @distMsg().get('text')
  distMsg: ->
    lclID = @model.get('message_id')
    messages.get(lclID)
  readYesNoHelper: ->
    if @model.get('read') == true then "-" else "*"
  render: =>
    $(@el).html(@template(@model.toJSON())) unless @distMsg() == undefined
    @
