class BB.Views.CnTbodyResources extends Backbone.Marionette.Layout

  # ----- configuration -----

  template: 'events/templates/CnTbodyResources'

  regions:
    links:  '#links'
    files:  '#files'
    photos: '#photos'

  # ----- initialization -----

  initialize: (options) ->
    @model = options.model

  onShow: ->
    @links.show(new BB.Views.CnTbodyResourcesLinks({model:   @model}))
    @files.show(new BB.Views.CnTbodyResourcesFiles({model:   @model}))
    @photos.show(new BB.Views.CnTbodyResourcesPhotos({model: @model}))

  # ----- methods -----

