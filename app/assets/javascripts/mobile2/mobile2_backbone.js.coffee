# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

window.member_template = '''
<div>
  First Name: <%= first_name %><br/>
  Last Name: <%= last_name %>
</div>
'''

window.member_index_template = '''
<a href="#member?id=<%=id%>"><%= last_name %></a>
'''

class @Member extends  Backbone.Model

class @MemberShowView extends Backbone.View
  initialize: ->
    @template = _.template(member_template)
  render: =>
    $(@el).html(@template(@model.toJSON()))
    @

class @MemberIndexView extends Backbone.View
  tagName:    "li"
  initialize: ->
    @template = _.template(member_index_template)
  render: =>
    $(@el).html(@template(@model.toJSON()))
    @

class @Members extends Backbone.Collection
  model: Member
  url:   "/mobile2/members"

class @MembersView extends Backbone.View
  el: "#roster_view"
  render: =>
    $(@el).html("")
    members.each (member) ->
      view = new MemberIndexView({model: member})
      $("#roster_view").append(view.render().el)
    $(@el).listview("refresh")
    @

class @Message extends Backbone.Model

class @Messages extends Backbone.Collection
  model: Message
  url:   "/mobile2/messages"

