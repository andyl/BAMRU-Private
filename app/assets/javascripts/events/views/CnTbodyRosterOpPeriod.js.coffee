class BB.Views.CnTbodyRosterOpPeriod extends Backbone.Marionette.ItemView

  # ----- configuration -----

  template: 'events/templates/CnTbodyRosterOpPeriod'

  templateHelpers: -> BB.Helpers.CnTbodyRosterOpPeriodHelpers

  # ----- initialization -----

  initialize: (options) ->
    @model      = options.model           # Period
    @collection = @model.participants     # Participants
    @collection.fetch() if @collection.url.search('undefined') == -1
    @pubSub = new BB.PubSub.Base(@collection)
    @memberField = "#memberField#{@model.id}"
    @guestLink   = "#createGuestLink#{@model.id}"
    @bindTo(@collection, 'add remove reset', @setSearchBox, this)
    @bindTo(BB.vent, 'cmd:ToggleAddParticipant',  @toggleAddParticipant,    this)
    @bindTo(BB.rosterState, 'change', @reRender, this)

  reRender: ->
    @render()
    @onShow()

  events:
    'click .deletePeriod'    : 'deletePeriod'
    'blur .memberField'      : 'onBlurSearch'
    'keyup .memberField'     : 'toggleGuestLink'
    'focus .memberField'     : 'onFocusSearch'
    'click .createGuestLink' : 'createGuest'
    'click .rsvpLink'        : 'rsvpLink'
    'click .selectPeriod'    : 'selectPeriod'

  onShow: ->
    @$el.css('font-size', '8pt')
#    @$el.find('.tablesorter').tablesorter()
    @$el.find('.tablesorter td, .tablesorter th').css('font-size', '8pt')
    opts = {model: @model, collection: @collection}
    new BB.Views.CnTbodyRosterOpParticipants(opts).render()
    @setSearchBox()

  onClose: ->
    @pubSub.close()

  # ----- guest links -----

  showGuestLink: ->
    @$el.find(@guestLink).show()

  rsvpLink: (ev) ->
    ev?.preventDefault()
    alert("Link to RSVP: Under Construction")

  createGuest: (ev) ->
    ev?.preventDefault()
    alert("Create Guest: Under Construction")

  toggleGuestLink: ->
    fieldVal = @$el.find(@memberField).val()
    if fieldVal.length > 1
      @showGuestLink()
      @collection.findMatches(fieldVal)
    else
      @$el.find(@guestLink).hide()
      @collection.clearMatches()

  # ----- add participant box -----

  toggleAddParticipant: ->
    if $(@memberField).is(':focus')
      $(@memberField).blur().val('')
    else
      $(@memberField).focus().val('')

  onFocusSearch: ->
    @collection.clearMatches()
    @$el.find(@memberField).css('background', 'yellow')

  onBlurSearch: ->
    @$el.find(@memberField).css('background', 'white').val('')
    hideLink = => @$el.find(@guestLink).hide()
    setTimeout(hideLink, 400)
    @collection.clearMatches()

  # ----- auto complete -----

  setSearchBox: ->
    @$el.find(@guestLink).hide()
    @collection.clearMatches()
    participantIDs = @collection.map (p) -> p.get('member_id')
    tgtList = _.select(BB.members.autoCompleteRoster(), (ele) -> ! _.contains(participantIDs, ele.memberId))
    autoOpts =
      source: tgtList
      minLength: 2
      select: (event, ui) => @autoCompleteAddParticipant(ui.item.memberId)
    @$el.find(@memberField).autocomplete(autoOpts)

  resetInputForm: ->
    resetFunc = =>
      @$el.find(@memberField).val('').focus()
      @$el.find(@guestLink).hide()
    setTimeout(resetFunc, 250)

  # ----- create participant -----

  autoCompleteAddParticipant: (memberId) ->
    @createParticipant(memberId)
    @setSearchBox()
    @resetInputForm()

  createParticipant: (memberId) ->
    periodId = @model.get('id')
    opts =
      period_id:  periodId
      member_id:  memberId
      updated_at: moment().strftime("%Y-%m-%d %H:%M")
      newMember: true
    participant = new BB.Models.Participant(opts)
    participant.urlRoot = "/eapi/periods/#{@model.get('id')}/participants"
    participant.save()
    @collection.add(participant)
    @removeHighLight(participant)

  removeHighLight: (model) ->
    clearHighLight = => model.unset('newMember')
    setTimeout(clearHighLight, 3000)

  # ----- delete period -----

  deletePeriod: (ev) ->
    ev?.preventDefault()
    @model.destroy()

  # ----- misc -----

  selectPeriod: (ev) ->
    ev?.preventDefault()
    BB.vent.trigger('cmd:SetActivePeriod', @model.id)

