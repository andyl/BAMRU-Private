class BB.Views.CnTbodyResourcesPhotos extends Backbone.Marionette.ItemView

  # ----- configuration -----

  template: 'events/templates/CnTbodyResourcesPhotos'

  templateHelpers: ->
    base = { eventPhotos: @model.eventPhotos }
    _.extend(base, BB.Helpers.CnTbodyResourcesPhotosHelpers)

  # ----- initialization -----

  initialize: (options) ->
    @model = options.model                          # Event
    @collection = @model.eventPhotos                # EventPhotos
    @bindTo(@collection, 'reset',  @render, this)

  events:
    'click #addNewPhoto'       : 'showNewPhotoForm'
    'click #cancelPhotoButton' : 'hideNewPhotoForm'
    'click #createPhotoButton' : 'createPhoto'
    'click .editPhoto'         : 'editPhoto'
    'click .deletePhoto'       : 'deletePhoto'
    'click #updatePhotoButton' : 'updatePhoto'

  onShow: ->
    console.log "doing it", $('#myForm')


  # ----- methods -----

  showNewPhotoForm: (ev) ->
    ev?.preventDefault()
    @$el.find('#urlField, #capField').attr('value','')
    @$el.find('#createPhotoButton').show()
    @$el.find('#updatePhotoButton').hide()
    @$el.find('#photoForm').show()
    @$el.find('#urlField').focus()
    @$el.find('#addNewPhoto').hide()

  hideNewPhotoForm: (ev) ->
    ev?.preventDefault()
    @$el.find('#photoForm').hide()
    @$el.find('#addNewPhoto').show()

  createPhoto: (ev) ->
    ev?.preventDefault()
    opts =
      beforeSubmit: (arr, form, options) ->
        console.log "SUBMITTING", arr, form, options
      beforeSend: (xhr) ->
        console.log "SEND", xhr
      success: (data, status) =>
        @hideNewPhotoForm()
        photo = new BB.Models.EventPhoto(data)
        photo.urlRoot = "/eapi/events/#{@model.get('id')}/event_photos"
        @collection.add(photo)
        window.zzz = @collection
        @render()
      error: (xhr, status, msg) ->
        console.log "ERROR", xhr, status, msg
    $('#myForm').ajaxSubmit(opts)


  deletePhoto: (ev) ->
    ev?.preventDefault()
    photoId = $(ev.target).data('id')
    photo = @collection.get(photoId).destroy()
    @.render()

  editPhoto: (ev) ->
    ev?.preventDefault()
    photoId = $(ev.target).data('id')
    photo   = @collection.get(photoId)
    @$el.find('#urlField').attr('value', photo.get('site_url'))
    @$el.find('#capField').attr('value', photo.get('caption'))
    @$el.find('#createPhotoButton').hide()
    @$el.find('#updatePhotoButton').show()
    @$el.find('#updatePhotoButton').data('photoId', photo.get('id'))
    @$el.find('#photoForm').show()
    @$el.find('#urlField').focus()
    @$el.find('#addNewPhoto').hide()

  updatePhoto: (ev) ->
    ev?.preventDefault()
    photoId = $(ev.target).data('photoId')
    photo   = @collection.get(photoId)
    opts =
      site_url: $('#urlField').val()
      caption:  $('#capField').val()
    photo.save(opts)
    @.render()
