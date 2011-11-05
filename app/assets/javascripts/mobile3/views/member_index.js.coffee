window.member_index_template = '''
<a class="memlink" data-memid="<%= id %>" href="#member"><%= first_name %> <%= last_name %> (<%= typ %>)</a>
'''

class @M3_MemberIndexView extends M3_CommonView
  tagName:    "li"
  initialize: ->
    @template = _.template(member_index_template)
  render: =>
    $(@el).html(@template(@model.toJSON()))
    @
