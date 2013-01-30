
window.distribution_index_template = '''
<a class=nav href="#messages/<%= message_id %>"><%= message_id %> - <%= this.gText() %></a>
'''

class @M4_DistributionIndexView extends M4_CommonView
  tagName:    "li"
  initialize: ->
    @template = _.template(distribution_index_template)
  gText: ->
    @distMsg().get('text')
  distMsg: ->
    lclID = @model.get('message_id')
    messages.get(lclID)
  render: =>
    $(@el).html(@template(@model.toJSON())) unless @distMsg() == undefined
    @
