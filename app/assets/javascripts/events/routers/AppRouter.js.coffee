BB.Routers.AppRouter = Backbone.Marionette.AppRouter.extend

  routes:
    'events'              : "index"
    'events/'             : "index"
    'events/new'          : "new"
    'events/new/'         : "new"
    'events/:id'          : "show"
    'events/:id/'         : "show"
    'events/:id/edit'     : "edit"
    'events/:id/edit/'    : "edit"
    'events/:id/roster'   : "roster"
    'events/:id/roster/'  : "roster"
    'events/:id/media'    : "media"
    'events/:id/media/'   : "media"
    'events/:id/summary'  : "summary"
    'events/:id/summary/' : "summary"
    'events/*path'        : "default"

  initialize: ->
    # ----- state obj -----
    BB.UI.filterState        = new BB.Models.UiState()
    # ----- event collection -----
    json_data = JSON.parse(_.string.unescapeHTML($('#json_data').text()))
    BB.Collections.events = new BB.Collections.Events(json_data)
    BB.Collections.filteredEvents = new BB.Collections.FilteredEvents(BB.Collections.events)
    @fEvents = BB.Collections.filteredEvents
    @fEvents.filter(BB.UI.filterState.toJSON())
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

  media: (id) ->
    console.log "rendering media for #{id}"
    @_render {modelId: id, page: 'media'}

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
    if @fEvents.get(opts.modelId)
      @appLayout.showTabs(opts)
    else
      @_showMissingEvent(opts.modelId)
    
