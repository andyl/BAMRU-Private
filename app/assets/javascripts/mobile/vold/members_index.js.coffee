class @M3_MembersIndexView extends Backbone.View
  el: "#members"
  render: =>
    $(@el).html("")
    members.each (member) ->
      view = new M3_MemberIndexView({model: member})
      $("#members").append(view.render().el)
    @