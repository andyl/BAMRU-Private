# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

window.member_template = '''
<div>
  First Name <%= first_name %><br/>
  Last Name <%= last_name %>
</div>
'''

class @Member extends  Backbone.Model
#  defaults:
#    url: '/mobile2/members'

class @MemberView extends Backbone.View
  initialize: ->
    @template = _.template(member_template)
  render: =>
    $(@el).html(@template(@model.toJSON()))
    @


class @Members extends Backbone.Collection
  model: Member
  url:   "/memberz"

class @Message extends Backbone.Model

class @Messages extends Backbone.Collection

