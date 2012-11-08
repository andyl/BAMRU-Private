class BB.Views.CnTbodyMedia extends Backbone.Marionette.Layout

  # ----- configuration -----

  template: 'events/templates/CnTbodyMedia'

  regions:
    links:  '#links'
    files:  '#files'
    photos: '#photos'

  # ----- initialization -----

  initialize: (options) ->
    @model = options.model

  onShow: ->
    @links.show(new BB.Views.CnTbodyMediaLinks({model:   @model}))
    @files.show(new BB.Views.CnTbodyMediaFiles({model:   @model}))
    @photos.show(new BB.Views.CnTbodyMediaPhotos({model: @model}))

  # ----- methods -----

