
window.member_show_template = '''
<div>
  First Name: <%= first_name %><br/>
  Last Name: <%= last_name %>
</div>
'''

class @MemberShowView extends Backbone.View
  initialize: ->
    @template = _.template(member_show_template)
  render: =>
    $(@el).html(@template(@model.toJSON()))
    @