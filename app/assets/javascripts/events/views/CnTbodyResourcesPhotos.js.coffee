class BB.Views.CnTbodyResourcesPhotos extends Backbone.Marionette.ItemView

  # ----- configuration -----

  template: 'events/templates/CnTbodyResourcesPhotos'

  templateHelpers: ->
    base = { eventPhotos: @model.eventPhotos }
    _.extend(base, BB.Helpers.CnTbodyMediaPhotosHelpers)

  # ----- initialization -----

  initialize: (options) ->
    @model = options.model                          # Event
    @collection = @model.eventPhotos                # EventPhotos
#    @bindTo(@collection, 'reset',  @render, this)

#  events:
#    'click #addNewPhoto'       : 'showNewPhotoForm'
#    'click #cancelPhotoButton' : 'hideNewPhotoForm'
#    'click #createPhotoButton' : 'createPhoto'
#    'click .editPhoto'         : 'editPhoto'
#    'click .deletePhoto'       : 'deletePhoto'
#    'click #updatePhotoButton' : 'updatePhoto'

  # ----- methods -----

#  showNewPhotoForm: (ev) ->
#    ev?.preventDefault()
#    @$el.find('#urlField, #capField').attr('value','')
#    @$el.find('#createPhotoButton').show()
#    @$el.find('#updatePhotoButton').hide()
#    @$el.find('#photoForm').show()
#    @$el.find('#urlField').focus()
#    @$el.find('#addNewPhoto').hide()
#
#  hideNewPhotoForm: (ev) ->
#    ev?.preventDefault()
#    @$el.find('#photoForm').hide()
#    @$el.find('#addNewPhoto').show()
#
#  createPhoto: (ev) ->
#    opts =
#      member_id: BB.currentMember.get('id')
#      event_id:  @model.get('id')
#      site_url:  $('#urlField').val()
#      caption:   $('#capField').val()
#    photo = new BB.Models.EventPhoto(opts)
#    photo.urlRoot = "/eapi/events/#{@model.get('id')}/event_photos"
#    result = photo.save()
#    @collection.add(photo)
#    @collection.fetch()
#    @.render()
#
#  deletePhoto: (ev) ->
#    ev?.preventDefault()
#    photoId = $(ev.target).data('id')
#    photo = @collection.get(photoId).destroy()
#    @.render()
#
#  editPhoto: (ev) ->
#    ev?.preventDefault()
#    photoId = $(ev.target).data('id')
#    photo   = @collection.get(photoId)
#    @$el.find('#urlField').attr('value', photo.get('site_url'))
#    @$el.find('#capField').attr('value', photo.get('caption'))
#    @$el.find('#createPhotoButton').hide()
#    @$el.find('#updatePhotoButton').show()
#    @$el.find('#updatePhotoButton').data('photoId', photo.get('id'))
#    @$el.find('#photoForm').show()
#    @$el.find('#urlField').focus()
#    @$el.find('#addNewPhoto').hide()
#
#  updatePhoto: (ev) ->
#    ev?.preventDefault()
#    photoId = $(ev.target).data('photoId')
#    photo   = @collection.get(photoId)
#    opts =
#      site_url: $('#urlField').val()
#      caption:  $('#capField').val()
#    photo.save(opts)
#    @.render()
