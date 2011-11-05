

window.distribution_index_template = '''
<a class="msglink" data-msgid="<%= message_id %>" href="#message"><%= message_id %> - <%= this.gtext() %></a>
'''

class @M2_DistributionIndexView extends M2_CommonView
  tagName:    "li"
  initialize: ->
    @template = _.template(distribution_index_template)
  gtext: -> @model.get('message').get('text')
  render: =>
    $(@el).html(@template(@model.toJSON()))
    @
