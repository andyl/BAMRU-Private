class BB.Views.CnTbodyResourcesFiles extends Backbone.Marionette.ItemView

  # ----- configuration -----

  template: 'events/templates/CnTbodyResourcesFiles'

  templateHelpers: ->
    base = { eventFiles: @model.eventFiles }
    _.extend(base, BB.Helpers.CnTbodyResourcesFilesHelpers)

  # ----- initialization -----

  initialize: (options) ->
    @model = options.model                          # Event
    @collection = @model.eventFiles                 # EventFiles
    @bindTo(@collection, 'reset',  @render, this)

  events:
    'click #addNewFile'       : 'showNewFileForm'
    'click #cancelFileButton' : 'hideNewFileForm'
    'click #createFileButton' : 'createFile'
    'click .editFile'         : 'editFile'
    'click .deleteFile'       : 'deleteFile'
    'click #updateFileButton' : 'updateFile'

  onShow: ->
    console.log "doing it", $('#myForm')


  # ----- methods -----

  showNewFileForm: (ev) ->
    ev?.preventDefault()
    @$el.find('#urlField, #capField').attr('value','')
    @$el.find('#createFileButton').show()
    @$el.find('#updateFileButton').hide()
    @$el.find('#fileForm').show()
    @$el.find('#urlField').focus()
    @$el.find('#addNewFile').hide()

  hideNewFileForm: (ev) ->
    ev?.preventDefault()
    @$el.find('#fileForm').hide()
    @$el.find('#addNewFile').show()

  createFile: (ev) ->
    console.log "CREATING FILE!!"
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
        window.zzz = @collection
        @render()
      error: (xhr, status, msg) ->
        console.log "ERROR", xhr, status, msg
    $('#myFileForm').ajaxSubmit(fileOpts)

  deleteFile: (ev) ->
    ev?.preventDefault()
    fileId = $(ev.target).data('id')
    file = @collection.get(fileId).destroy()
    @.render()

  editFile: (ev) ->
    ev?.preventDefault()
    fileId = $(ev.target).data('id')
    file   = @collection.get(fileId)
    @$el.find('#urlField').attr('value', file.get('site_url'))
    @$el.find('#capField').attr('value', file.get('caption'))
    @$el.find('#createFileButton').hide()
    @$el.find('#updateFileButton').show()
    @$el.find('#updateFileButton').data('fileId', file.get('id'))
    @$el.find('#fileForm').show()
    @$el.find('#urlField').focus()
    @$el.find('#addNewFile').hide()

  updateFile: (ev) ->
    ev?.preventDefault()
    fileId = $(ev.target).data('fileId')
    file   = @collection.get(fileId)
    opts =
      site_url: $('#urlField').val()
      caption:  $('#capField').val()
    file.save(opts)
    @.render()
