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
    'click #addNewLink'       : 'showNewLinkForm'
    'click #cancelLinkButton' : 'hideNewLinkForm'
    'click #createLinkButton' : 'createLink'
    'click .editLink'         : 'editLink'
    'click .deleteLink'       : 'deleteLink'
    'click #updateLinkButton' : 'updateLink'

  # ----- methods -----

  showNewLinkForm: (ev) ->
    ev?.preventDefault()
    @$el.find('#urlField, #capField').attr('value','')
    @$el.find('#createLinkButton').show()
    @$el.find('#updateLinkButton').hide()
    @$el.find('#linkForm').show()
    @$el.find('#urlField').focus()
    @$el.find('#addNewLink').hide()

  hideNewLinkForm: (ev) ->
    ev?.preventDefault()
    @$el.find('#linkForm').hide()
    @$el.find('#addNewLink').show()

  createLink: (ev) ->
    opts =
      member_id: BB.currentMember.get('id')
      event_id:  @model.get('id')
      site_url:  $('#urlField').val()
      caption:   $('#capField').val()
    link = new BB.Models.EventLink(opts)
    link.urlRoot = "/eapi/events/#{@model.get('id')}/event_links"
    result = link.save()
    @collection.add(link)
    @collection.fetch()
    @.render()

  deleteLink: (ev) ->
    ev?.preventDefault()
    linkId = $(ev.target).data('id')
    link = @collection.get(linkId).destroy()
    @.render()
    
  editLink: (ev) ->
    ev?.preventDefault()
    linkId = $(ev.target).data('id')
    link   = @collection.get(linkId)
    @$el.find('#urlField').attr('value', link.get('site_url'))
    @$el.find('#capField').attr('value', link.get('caption'))
    @$el.find('#createLinkButton').hide()
    @$el.find('#updateLinkButton').show()
    @$el.find('#updateLinkButton').data('linkId', link.get('id'))
    @$el.find('#linkForm').show()
    @$el.find('#urlField').focus()
    @$el.find('#addNewLink').hide()

  updateLink: (ev) ->
    ev?.preventDefault()
    linkId = $(ev.target).data('linkId')
    link   = @collection.get(linkId)
    opts =
      site_url: $('#urlField').val()
      caption:  $('#capField').val()
    link.save(opts)
    @.render()
