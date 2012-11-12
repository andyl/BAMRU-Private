class BB.Views.CnNewForm extends BB.Views.CnSharedForm

  save: (event) ->
    event?.preventDefault()
    params = Backbone.Syphon.serialize(this)
    if params.finish != ""
      if params.start > params.finish
        [params.start, params.finish] = [params.finish, params.start]
    params.title    = "TBA" if _.string.isBlank(params.title)
    params.location = "TBA" if _.string.isBlank(params.location)
    params.leaders  = "TBA" if _.string.isBlank(params.leaders)
    yesFunc = (call) =>
      console.log "SUCCESS SAVE", call, @model.id, @model
      BB.Collections.events.add(@model)
      BB.Collections.filteredEvents.reFilter()
      BB.Routers.app.navigate("/events/#{@model.get('id')}", {trigger: true})
    noFunc = ->
      alert "THERE WAS AN ERROR"
    @model.set params
    @model.save(null, success: yesFunc, error: noFunc)


  cancel: (event) ->
    event?.preventDefault()
    BB.vent.trigger("click:CnTabsOverviewCancelClone")
