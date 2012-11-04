class BB.Views.CnTbodyRosterOpPeriod extends Backbone.Marionette.ItemView

  # ----- configuration -----

  template: 'events/templates/CnTbodyRosterOpPeriod'

  templateHelpers: -> BB.Helpers.CnTbodyRosterOpPeriodHelpers

  # ----- initialization -----

  initialize: (options) ->
    @model      = options.model           # Period
    @collection = @model.participants     # Participants
    @collection.fetch() if @collection.url.search('undefined') == -1

  onShow: ->
    @$el.css('font-size', '8pt')
    @$el.find('.tablesorter').tablesorter()
    @$el.find('.tablesorter td, .tablesorter th').css('font-size', '8pt')
    opts = {model: @model, collection: @collection}
    new BB.Views.CnTbodyRosterOpParticipants(opts).render()

  events:
    'click .createParticipantButton'    : 'createParticipant'
    'click .deletePeriod'               : 'deletePeriod'

  # ----- methods -----

  deletePeriod: (ev) ->
    ev?.preventDefault()
    @model.destroy()

  createParticipant: (ev) ->
    ev?.preventDefault()
    opts =
      period_id: @model.get('id')
      member_id: @$el.find('#memberField').val()
    participant = new BB.Models.Participant(opts)
    participant.urlRoot = "/eapi/periods/#{@model.get('id')}/participants"
    participant.save()
    @collection.add(participant)
    @$el.find('#memberField').val('')
    @$el.find('#memberField').focus()
