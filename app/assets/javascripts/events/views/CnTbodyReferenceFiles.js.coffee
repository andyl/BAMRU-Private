class BB.Views.CnTbodyReferenceFiles extends Backbone.Marionette.ItemView

  # ----- configuration -----

  template: 'events/templates/CnTbodyReferenceFiles'

  templateHelpers: ->
    base = { eventFiles: @model.eventFiles }
    _.extend(base, BB.Helpers.CnTbodyReferenceFilesHelpers)

  # ----- initialization -----

  initialize: (options) ->
    @model = options.model                          # Event
    @collection = @model.eventFiles                 # EventFiles
    @bindTo(@collection, 'reset',  @render, this)

  events:
    'click #addNewFile'         : 'showNewFileForm'
    'click #cancelCreateButton' : 'hideNewFileForm'
    'click #createFileButton'   : 'createFile'
    'click .editFile'           : 'showUpdateFileForm'
    'click #cancelUpdateButton' : 'hideUpdateFileForm'
    'click .deleteFile'         : 'deleteFile'
    'click #updateFileButton'   : 'updateFile'

  onShow: ->
#    console.log "doing it FILE", $('#myForm')

  # ----- methods -----

  showNewFileForm: (ev) ->
    ev?.preventDefault()
    @$el.find('#capCreateField').attr('value','')
    @$el.find('#createFileButton').show()
    @$el.find('#fileCreateForm').show()
    @$el.find('#fileUpdateForm').hide()
    @$el.find('#addNewFile').hide()

  hideNewFileForm: (ev) ->
    ev?.preventDefault()
    @$el.find('#fileCreateForm').hide()
    @$el.find('#addNewFile').show()

  createFile: (ev) ->
    ev?.preventDefault()
    fileOpts =
      beforeSubmit: (arr, form, options) ->
        console.log "SUBMITTING", arr, form, options
      beforeSend: (xhr) ->
        console.log "SEND", xhr
      success: (data, status) =>
        @hideNewFileForm()
        file = new BB.Models.EventFile(data)
        file.urlRoot = "/eapi/events/#{@model.get('id')}/event_files"
        @collection.add(file)
        @render()
      error: (xhr, status, msg) ->
        console.log "ERROR", xhr, status, msg
    $('#myFileCreateForm').ajaxSubmit(fileOpts)

  showUpdateFileForm: (ev) ->
    ev?.preventDefault()
    fileId = $(ev.target).data('id')
    file   = @collection.get(fileId)
    @$el.find('#capUpdateField').attr('value', file.get('caption')).focus()
    @$el.find('#updateFileButton').data('fileId', file.get('id'))
    @$el.find('#addNewFile').hide()
    @$el.find('#fileCreateForm').hide()
    @$el.find('#fileUpdateForm').show()

  hideUpdateFileForm: (ev) ->
    ev?.preventDefault()
    @$el.find('#addNewFile').show()
    @$el.find('#fileUpdateForm').hide()

  updateFile: (ev) ->
    ev?.preventDefault()
    fileId = $(ev.target).data('fileId')
    file   = @collection.get(fileId)
    opts =
      caption:  $('#capUpdateField').val()
    file.save(opts)
    @.render()

  deleteFile: (ev) ->
    ev?.preventDefault()
    if confirm("Are you sure you want to remove this file?")
      fileId = $(ev.target).data('id')
      file = @collection.get(fileId).destroy()
      @.render()
