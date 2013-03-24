class BB.Views.CnTbodyReferenceLinks extends Backbone.Marionette.ItemView

  # ----- configuration -----

  template: 'events/templates/CnTbodyReferenceLinks'

  templateHelpers: ->
    base = { eventLinks: @model.eventLinks }
    _.extend(base, BB.Helpers.CnTbodyReferenceLinksHelpers)

  # ----- initialization -----

  initialize: (options) ->
    @model = options.model                            # Event
    @collection = @model.eventLinks                   # EventLinks
    @bindTo(@collection, 'reset',  @render, this)

  events:
    'click #addNewLink'             : 'showNewLinkForm'
    'click #cancelCreateLinkButton' : 'hideNewLinkForm'
    'click #createLinkButton'       : 'createLink'
    'click .editLink'                : 'showUpdateLinkForm'
    'click #cancelUpdateButton'       : 'hideUpdateLinkForm'    
    'click .deleteLink'             : 'deleteLink'
    'click #updateLinkButton'       : 'updateLink'

  # ----- methods -----

  showNewLinkForm: (ev) ->
    ev?.preventDefault()
    @$el.find('#capCreateField').attr('value','')
    @$el.find('#createLinkButton').show()
    @$el.find('#linkCreateForm').show()
    @$el.find('#urlField').focus()
    @$el.find('#addNewLink').hide()

  hideNewLinkForm: (ev) ->
    ev?.preventDefault()
    @$el.find('#linkCreateForm').hide()
    @$el.find('#addNewLink').show()

  createLink: (ev) ->
    ev?.preventDefault()
    opts =
      member_id: BB.currentMember.get('id')
      event_id:  @model.get('id')
      site_url:  @$el.find('#urlField').val()
      caption:   @$el.find('#capCreateField').val()
    link = new BB.Models.EventLink(opts)
    link.urlRoot = "/eapi/events/#{@model.get('id')}/event_links"
    result = link.save()
    @collection.add(link)
    @.render()
    @collection.fetch()

  showUpdateLinkForm: (ev) ->
    ev?.preventDefault()
    linkId = $(ev.target).data('id')
    link   = @collection.get(linkId)
    @$el.find('#capUpdateField').attr('value', link.get('caption')).focus()
    @$el.find('#updateLinkButton').data('linkId', link.get('id'))
    @$el.find('#addNewLink').hide()
    @$el.find('#linkCreateForm').hide()
    @$el.find('#linkUpdateForm').show()

  hideUpdateLinkForm: (ev) ->
    ev?.preventDefault()
    @$el.find('#addNewLink').show()
    @$el.find('#linkUpdateForm').hide()    

  updateLink: (ev) ->
    ev?.preventDefault()
    linkId = $(ev.target).data('linkId')
    link   = @collection.get(linkId)
    opts =
      caption:  $('#capUpdateField').val()
    link.save(opts)
    @.render()

  deleteLink: (ev) ->
    ev?.preventDefault()
    linkId = $(ev.target).data('id')
    link = @collection.get(linkId).destroy()
    @.render()

