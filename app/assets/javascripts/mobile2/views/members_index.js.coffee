class @MembersIndexView extends Backbone.View
  el: "#roster_view"
  render: =>
    $(@el).html("")
    members.each (member) ->
      view = new MemberIndexView({model: member})
      $("#roster_view").append(view.render().el)
    $(@el).listview("refresh")
    $('.memlink').click ->
      localStorage['memID'] = $(this).data('memid')
    @