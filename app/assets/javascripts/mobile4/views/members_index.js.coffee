class @M4_MembersIndexView extends Backbone.View
  el: "#members"
  render: =>
    $(@el).html("")
    members.each (member) ->
      view = new M4_MemberIndexView({model: member})
      $("#members").append(view.render().el)
    @