BB.Routers.AppRouter = Backbone.Marionette.AppRouter.extend

  routes:
    'events'                : "index"
    'events/'               : "index"
    'events/new'            : "new"
    'events/new/'           : "new"
    'events/:id'            : "show"
    'events/:id/'           : "show"
    'events/:id/edit'       : "edit"
    'events/:id/edit/'      : "edit"
    'events/:id/roster'     : "roster"
    'events/:id/roster/'    : "roster"
    'events/:id/journal'    : "journal"
    'events/:id/journal/'   : "journal"
    'events/:id/resources'  : "resources"
    'events/:id/resources/' : "resources"
    'events/:id/summary'    : "summary"
    'events/:id/summary/'   : "summary"
    'events/*path'          : "default"

  initialize: ->
    # ----- state obj -----
    BB.UI.filterState        = new BB.Models.UiState()
    # ----- event collection -----
    json_event_data = JSON.parse(_.string.unescapeHTML($('#json_event_data').text()))
    BB.Collections.events = new BB.Collections.Events(json_event_data)
    BB.Collections.filteredEvents = new BB.Collections.FilteredEvents(BB.Collections.events)
    @fEvents = BB.Collections.filteredEvents
    @fEvents.filter(BB.UI.filterState.toJSON())
    # ----- faye -----
    BB.faye = new Faye.Client(faye_server)
    BB.faye.subscribe("/events", (data) -> BB.pubSubEvents(data))
    # ----- current member -----
    json_member_data = JSON.parse(_.string.unescapeHTML($('#json_member_data').text()))
    BB.currentMember = new BB.Models.Member(json_member_data)
    # ----- all members -----
    BB.members = new BB.Collections.Members()
    BB.members.fetch()
    # ----- app view -----
    BB.Views.app = new BB.Views.AppLayout()
    @appLayout = BB.Views.app
    @appLayout.render()

  index: ->
    console.log "rendering index"
    @appLayout.content.show(new BB.Views.CnIndx());

  new: ->
    console.log "rendering new"
    @appLayout.content.show(new BB.Views.CnNew())

  show: (id) ->
    console.log "rendering show for #{id}"
    @_render {modelId: id, page: 'overview-show'}

  edit: (id) ->
    console.log "rendering edit for #{id}"
    @_render {modelId: id, page: 'overview-edit'}

  roster: (id) ->
    console.log "rendering roster for #{id}"
    @_render {modelId: id, page: 'roster'}

  journal: (id) ->
    console.log "rendering journal for #{id}"
    @_render {modelId: id, page: 'journal'}

  resources: (id) ->
    console.log "rendering resources for #{id}"
    @_render {modelId: id, page: 'resources'}

  summary: (id) ->
    console.log "rendering summary for #{id}"
    @_render {modelId: id, page: 'summary'}

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
    @appLayout.content.show(new BB.Views.CnMissingEvent({eventId: id, missingEventMessage: msg}))
    
  _render: (opts) ->
    if BB.Collections.events.get(opts.modelId)
      @appLayout.showTabs(opts)
    else
      @_showMissingEvent(opts.modelId)
    
