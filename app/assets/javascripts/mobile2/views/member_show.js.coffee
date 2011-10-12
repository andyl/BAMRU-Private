
window.member_show_template = '''
  <b><%= first_name %> <%= last_name %></b> - <%= full_roles %><br/>
'''

class @MemberShowView extends Backbone.View
  initialize: ->
    @template = _.template(member_show_template)
  render: =>
    heading = "asdf"
    $(@el).html(@template(@model.toJSON()))
    @