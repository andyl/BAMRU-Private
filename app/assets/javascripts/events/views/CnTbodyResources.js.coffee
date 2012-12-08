class BB.Views.CnTbodyResources extends Backbone.Marionette.Layout

  # ----- configuration -----

  template: 'events/templates/CnTbodyResources'

  regions:
    links:  '#links'
    photos: '#photos'
    files:  '#files'
    maps:   '#maps'

  # ----- initialization -----

  initialize: (options) ->
    @model = options.model          # Event
    @model.eventLinks.fetch()
    @model.eventPhotos.fetch()
    @model.eventFiles.fetch()

  onShow: ->
    @links.show(new BB.Views.CnTbodyResourcesLinks({model:   @model}))
    @photos.show(new BB.Views.CnTbodyResourcesPhotos({model: @model}))
    @files.show(new BB.Views.CnTbodyResourcesFiles({model:   @model}))
    @maps.show(new BB.Views.CnTbodyResourcesMaps({model: @model}))

  # ----- methods -----
