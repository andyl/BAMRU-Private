window.member_index_template = '''
<a class="nav" href="#members/<%= id %>"><%= first_name %> <%= last_name %> (<%= typ %>)</a>
'''

class @M4_MemberIndexView extends M4_CommonView
  tagName:    "li"
  initialize: ->
    @template = _.template(member_index_template)
  render: =>
    $(@el).html(@template(@model.toJSON()))
    @
