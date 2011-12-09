markAllLink = '''
<a href='#' id="markall" class='nav'>Mark all as read</a><hr/>
'''

class @M3_DistributionsIndexView extends Backbone.View
  el: "#inbox"
  render: =>
    $(@el).html("")
    if inbox.length == 0
      $("#inbox").append("<div class='center'>No Recent Inbox Messages</div>")
      return @
    if inbox.unreadCount() > 0 && navigator.onLine
      $("#inbox").append(markAllLink)
    inbox.each (dist) ->
      view = new M3_DistributionIndexView({model: dist})
      $("#inbox").append(view.render().el)
    @