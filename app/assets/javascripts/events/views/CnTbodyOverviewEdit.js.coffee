class BB.Views.CnTbodyOverviewEdit extends BB.Views.CnSharedForm

  save: (event) ->
    event?.preventDefault()
    params = Backbone.Syphon.serialize(this)
    params.title    = "TBA" if _.string.isBlank(params.title)
    params.location = "TBA" if _.string.isBlank(params.location)
    params.leaders  = "TBA" if _.string.isBlank(params.leaders)
    delete params.start
    delete params.finish
    @model.set params
    @model.updateBaseDates()
    @model.save()
    BB.vent.trigger("click:CnTabsOverviewShow")