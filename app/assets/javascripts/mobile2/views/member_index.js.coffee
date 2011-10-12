window.member_index_template = '''
<a href="#member?id=<%=id%>"><%= last_name %></a>
'''

class @MemberIndexView extends Backbone.View
  tagName:    "li"
  initialize: ->
    @template = _.template(member_index_template)
  render: =>
    $(@el).html(@template(@model.toJSON()))
    @
