class BB.Views.CnTbodyRosterMtPeriod extends Backbone.Marionette.ItemView

  # ----- configuration -----

  template: 'events/templates/CnTbodyRosterMtPeriod'

  templateHelpers: -> BB.Helpers.CnTbodyRosterMtPeriodHelpers

  # ----- initialization -----

  initialize: (options) ->
    @model      = options.model           # Period
    @collection = @model.participants     # Participants
    @collection.fetch() if @collection.url.search('undefined') == -1
    @bindTo(@collection, 'add remove reset', @setSearchBox, this)
    @pubSub = new BB.PubSub.Base(@collection)

  onShow: ->
    @$el.css('font-size', '8pt')
    @$el.find('.tablesorter td, .tablesorter th').css('font-size', '8pt')
    opts = {model: @model, collection: @collection}
    @subview = new BB.Views.CnTbodyRosterMtParticipants(opts)
    @subview.render()
    @setSearchBox()
    @bindTo(BB.vent, 'cmd:ToggleAddParticipant',  @toggleAddParticipant,    this)
    BB.hotKeys.enable("CnTbodyRosterMt")

  events:
    'blur #memberField'       : 'onBlurSearch'
    'keyup #memberField'      : 'toggleGuestLink'
    'focus #memberField'      : 'onFocusSearch'
    'click #createGuestLink'  : 'createGuest'

  onClose: ->
    @pubSub.close()
    BB.hotKeys.disable("CnTbodyRosterMt")

  # ----- methods -----

  showGuestLink: ->
    @$el.find('#createGuestLink').show()

  createGuest: (ev) ->
    ev?.preventDefault()
    alert("Create Guest: Under Construction")

  toggleAddParticipant: ->
    el = @$el.find('#memberField')
    el.val('')
    if el.is(':focus') then el.blur() else el.focus()

  onFocusSearch: ->
    @collection.clearMatches()
    @$el.find('#memberField').css('background', 'yellow')

  onBlurSearch: ->
    @$el.find('#memberField').css('background', 'white').val('')
    hideLink = => @$el.find('#createGuestLink').hide()
    setTimeout(hideLink, 400)
    @collection.clearMatches()

  setSearchBox: ->
    @$el.find('#createGuestLink').hide()
    @collection.clearMatches()
    participantIDs = @collection.map (p) -> p.get('member_id')
    tgtList = _.select(BB.members.autoCompleteRoster(), (ele) -> ! _.contains(participantIDs, ele.memberId))
    autoOpts =
      source: tgtList
      minLength: 2
      select: (event, ui) => @autoCompleteAddParticipant(ui.item.memberId)
    @$el.find('#memberField').autocomplete(autoOpts)

  toggleGuestLink: ->
    fieldVal = @$el.find('#memberField').val()
    if fieldVal.length > 1
      @showGuestLink()
      @collection.findMatches(fieldVal)
    else
      @$el.find('#createGuestLink').hide()
      @collection.clearMatches()

  resetInputForm: ->
    resetFunc = =>
      @$el.find('#memberField').val('').focus()
      @$el.find('#createGuestLink').hide()
    setTimeout(resetFunc, 250)

  autoCompleteAddParticipant: (memberId) ->
    @createParticipant(memberId)
    @setSearchBox()
    @resetInputForm()

  # ----- Create Participant -----

  createParticipant: (memberId) ->
    @resetInputForm()
    periodId = @model.get('id')
    opts =
      period_id: periodId
      member_id: memberId
      newMember: true
    participant = new BB.Models.Participant(opts)
    participant.urlRoot = "/eapi/periods/#{periodId}/participants"
    participant.save()
    @collection.add(participant)
    @removeHighLight(participant)

  removeHighLight: (model) ->
    clearHighLight = => model.unset('newMember')
    setTimeout(clearHighLight, 3000)

