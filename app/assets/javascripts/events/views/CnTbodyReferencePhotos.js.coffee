class BB.Views.CnTbodyReferencePhotos extends Backbone.Marionette.ItemView

  # ----- configuration -----

  template: 'events/templates/CnTbodyReferencePhotos'

  templateHelpers: ->
    base = { eventPhotos: @model.eventPhotos }
    _.extend(base, BB.Helpers.CnTbodyReferencePhotosHelpers)

  # ----- initialization -----

  initialize: (options) ->
    @model = options.model                          # Event
    @collection = @model.eventPhotos                # EventPhotos
    @bindTo(@collection, 'reset',  @render, this)

  events:
    'click #addNewPhoto'              : 'showNewPhotoForm'
    'click #cancelCreatePhotoButton'  : 'hideNewPhotoForm'
    'click #createPhotoButton'        : 'createPhoto'
    'click .editPhoto'                : 'showUpdatePhotoForm'
    'click #cancelUpdateButton'       : 'hideUpdatePhotoForm'
    'click .deletePhoto'              : 'deletePhoto'
    'click #updatePhotoButton'        : 'updatePhoto'

  onShow: ->
#    console.log "doing it", $('#myForm')

  # ----- methods -----

  showNewPhotoForm: (ev) ->
    ev?.preventDefault()
    @$el.find('#capCreateField').attr('value','')
    @$el.find('#createPhotoButton').show()
    @$el.find('#photoCreateForm').show()
    @$el.find('#photoUpdateForm').hide()
    @$el.find('#addNewPhoto').hide()

  hideNewPhotoForm: (ev) ->
    ev?.preventDefault()
    @$el.find('#photoCreateForm').hide()
    @$el.find('#addNewPhoto').show()

  createPhoto: (ev) ->
    ev?.preventDefault()
    opts =
      beforeSubmit: (arr, form, options) ->
        console.log "SUBMITTING", arr, form, options
      beforeSend: (xhr) =>
        @$el.find("#photoLoadingMsg").show()
        @hideNewPhotoForm()
      success: (data, status) =>
        @$el.find("#fileLoadingMsg").hide()
        photo = new BB.Models.EventPhoto(data)
        photo.urlRoot = "/eapi/events/#{@model.get('id')}/event_photos"
        @collection.add(photo)
        @render()
      error: (xhr, status, msg) ->
        console.log "ERROR", xhr, status, msg
    $('#myPhotoCreateForm').ajaxSubmit(opts)

  showUpdatePhotoForm: (ev) ->
    ev?.preventDefault()
    photoId = $(ev.target).data('id')
    photo   = @collection.get(photoId)
    @$el.find('#capUpdateField').attr('value', photo.get('caption')).focus()
    @$el.find('#updatePhotoButton').data('photoId', photo.get('id'))
    @$el.find('#addNewPhoto').hide()
    @$el.find('#photoCreateForm').hide()
    @$el.find('#photoUpdateForm').show()

  hideUpdatePhotoForm: (ev) ->
    ev?.preventDefault()
    @$el.find('#addNewPhoto').show()
    @$el.find('#photoUpdateForm').hide()

  updatePhoto: (ev) ->
    ev?.preventDefault()
    photoId = $(ev.target).data('photoId')
    photo   = @collection.get(photoId)
    opts =
      caption:  $('#capUpdateField').val()
    photo.save(opts)
    @.render()

  deletePhoto: (ev) ->
    ev?.preventDefault()
    photoId = $(ev.target).data('id')
    photo = @collection.get(photoId).destroy()
    @.render()


