class BB.Views.CnTbodyOverviewEdit extends BB.Views.CnSharedForm

  save: (event) ->
    event?.preventDefault()
    params = Backbone.Syphon.serialize(this)
    if params.finish != ""
      if params.start > params.finish
        [params.start, params.finish] = [params.finish, params.start]
    params.title    = "TBA" if _.string.isBlank(params.title)
    params.location = "TBA" if _.string.isBlank(params.location)
    params.leaders  = "TBA" if _.string.isBlank(params.leaders)
    @model.set params
    @model.save()
    BB.vent.trigger("click:CnTabsOverviewShow")