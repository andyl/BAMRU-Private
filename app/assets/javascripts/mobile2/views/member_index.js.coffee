window.member_index_template = '''
<a href="#member?id=<%=id%>&rand=<%= this.random_string() %>"><%= last_name %></a>
'''

class @MemberIndexView extends CommonView
  tagName:    "li"
  initialize: ->
    @template = _.template(member_index_template)
  render: =>
    $(@el).html(@template(@model.toJSON()))
    @
