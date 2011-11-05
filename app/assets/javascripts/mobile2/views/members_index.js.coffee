class @M2_MembersIndexView extends Backbone.View
  el: "#roster_view"
  render: =>
    $(@el).html("")
    members.each (member) ->
      view = new M2_MemberIndexView({model: member})
      $("#roster_view").append(view.render().el)
    $(@el).listview("refresh")
    @