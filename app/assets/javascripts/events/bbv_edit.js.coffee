window.BbvEdit = Backbone.View.extend

  className: "BbmEvent"

  tgt: -> $('#event_overview')

  genTemplate: ->
    text = $('#bb_edit_template').html()
    template = _.template(text)
    template(@model.toJSON())

  renderShow: ->
    bbvShow.render()
    @setNavToShow()

  setNavToShow: ->
    $('#overview-show-nav').show()
    $('#overview-edit-nav').hide()

  setNavToEdit: ->
    $('#overview-show-nav').hide()
    $('#overview-edit-nav').show()
    $('#overview-save-link').click   => @renderShow()
    $('#overview-cancel-link').click => @renderShow()

  render: ->
    $(@tgt()).html(@genTemplate())
    @setNavToEdit()
    @
