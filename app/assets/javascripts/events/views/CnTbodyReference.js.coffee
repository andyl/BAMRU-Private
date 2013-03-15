class BB.Views.CnTbodyReference extends Backbone.Marionette.Layout

  # ----- configuration -----

  template: 'events/templates/CnTbodyReference'

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
    @links.show(new BB.Views.CnTbodyReferenceLinks({model:   @model}))
    @photos.show(new BB.Views.CnTbodyReferencePhotos({model: @model}))
    @files.show(new BB.Views.CnTbodyReferenceFiles({model:   @model}))
    @maps.show(new BB.Views.CnTbodyReferenceMaps({model: @model}))

  # ----- methods -----
