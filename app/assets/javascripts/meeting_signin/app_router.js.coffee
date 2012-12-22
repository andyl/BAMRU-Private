BB.Routers.AppRouter = Backbone.Marionette.AppRouter.extend

  routes:
    'meeting_signin'                 : "index"
    'meeting_signin/'                : "index"
    'meeting_signin/:id'             : "home"
    'meeting_signin/:id/'            : "home"
    'meeting_signin/:id/first_time'  : "first_time"
    'meeting_signin/:id/first_time/' : "first_time"
    'meeting_signin/:id/returning'   : "returning"
    'meeting_signin/:id/returning/'  : "returning"
    'meeting_signin/:id/roster'      : "roster"
    'meeting_signin/:id/roster/'     : "roster"
    'meeting_signin/*path'           : "default"

  initialize: ->
    console.log "doing initialize"
    # ----- event collection -----
#    json_event_data = JSON.parse(_.string.unescapeHTML($('#json_event_data').text()))
#    BB.Collections.events = new BB.Collections.Events(json_event_data)
#    BB.Collections.filteredEvents = new BB.Collections.FilteredEvents(BB.Collections.events)
    # ----- faye -----
#    BB.PubSub.events = new BB.PubSub.Events(BB.Collections.events)
    # ----- current member -----
#    json_member_data = JSON.parse(_.string.unescapeHTML($('#json_member_data').text()))
#    BB.currentMember = new BB.Models.Member(json_member_data)
    # ----- create app layouts -----
    BB.Views.appIndex = new BB.Views.AppIndex()
    BB.Views.appEvent = new BB.Views.AppEvent()
    @appEvent = BB.Views.appEvent
    @appIndex = BB.Views.appIndex
    # ----- all members -----
#    BB.members = new BB.Collections.Members()
#    BB.members.fetch()

  index: ->
    console.log "rendering index"
    @appIndex.render().content.show(new BB.Views.Index)

  home: (id) ->
    console.log "rendering home for #{id}"
    @appIndex.render().content.show(new BB.Views.Home)

  first_time: (id) ->
    console.log "rendering first_time for #{id}"
    @_render {modelId: id, page: 'first_time'}

  returning: (id) ->
    console.log "rendering returning for #{id}"
    @_render {modelId: id, page: 'returning'}

  roster: (id) ->
    console.log "rendering roster for #{id}"
    @_render {modelId: id, page: 'roster'}

  default: ->
    console.log "rendering the default route"
    $('#content').text("This is the default route")

  _missingEventMsg: (id) ->
    if BB.Collections.events.get(id)
      "Event is in the datbase but not in the filtered list."
    else
      "Event is not in the database."
      
  _showMissingEvent: (id) ->
    msg = @_missingEventMsg(id)
    @appEvent.content.show(new BB.Views.CnMissingEvent({eventId: id, missingEventMessage: msg}))
    
  _render: (opts) ->
    @appEvent.render().showContent(opts)
#    if BB.Collections.events.get(opts.modelId)
#      @appEvent.showContent(opts)
#    else
#      @_showMissingEvent(opts.modelId)
    
