class BB.Views.CnTbodyOverviewEdit extends BB.Views.CnSharedForm

  save: (event) ->
    event?.preventDefault()
    window.params = Backbone.Syphon.serialize(this)
    params.title    = "TBA" if _.string.isBlank(params.title)
    params.location = "TBA" if _.string.isBlank(params.location)
    params.leaders  = "TBA" if _.string.isBlank(params.leaders)
    delete params.start
    delete params.finish
    console.log "PRE", params.startDate, params.startTime, "|", params.finishDate, params.finishTime
    @model.set params
    console.log "SET", @model.get('startDate'), @model.get('startTime'), "|", @model.get('finishDate'), @model.get('finishTime')
    @model.updateBaseDates()
    console.log "PST", @model.get('start'), "|", @model.get('finish')
    @model.save()
    window.mm = @model
    console.log "---"
    BB.vent.trigger("click:CnTabsOverviewShow")