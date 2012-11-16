class BB.Views.CnTbodyRosterOpPeriod extends Backbone.Marionette.ItemView

  # ----- configuration -----

  template: 'events/templates/CnTbodyRosterOpPeriod'

  templateHelpers: -> BB.Helpers.CnTbodyRosterOpPeriodHelpers

  # ----- initialization -----

  initialize: (options) ->
    @model      = options.model           # Period
    @collection = @model.participants     # Participants
    @collection.url = "/eapi/periods/#{@model.id}/participants"
    @collection.fetch()
    @pubSub = new BB.PubSub.Participants(@collection)
    @memberField = "#memberField#{@model.id}"
    @guestLink   = "#createGuestLink#{@model.id}"
    @bindTo(@collection, 'add remove reset', @setSearchBox, this)
    @bindTo(BB.vent, 'cmd:ToggleAddParticipant',  @toggleAddParticipant,    this)
    @bindTo(BB.rosterState, 'change', @reRender, this)
    @bindTo(@model,         'change', @reRender, this)

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
    'click .addParticipant'  : 'addParticipant'

  onShow: ->
    @$el.css('font-size', '8pt')
#    @$el.find('.tablesorter').tablesorter()
    @$el.find('.tablesorter td, .tablesorter th').css('font-size', '8pt')
    opts = {model: @model, collection: @collection}
    new BB.Views.CnTbodyRosterOpParticipants(opts).render()
    BB.hotKeys.rebindAllKeySets()
    setTimeout(@setSearchBox, 250)
    @focusAddParticipant()

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

  focusAddParticipant: ->
    if BB.highlightAddParticipant == @model.id
      delete BB.highlightAddParticipant
      $(@memberField).focus().val('')

  toggleAddParticipant: ->
    return unless @model.get('isActive')
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

  setSearchBox: =>
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
    participant.urlRoot = "/eapi/periods/#{periodId}/participants"
    opts =
      success: =>
        @collection.add(participant)
        @removeHighLight(participant)
    participant.save({}, opts)

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

  addParticipant: (ev) ->
    ev?.preventDefault()
    BB.highlightAddParticipant = @model.id
    BB.vent.trigger('cmd:SetActivePeriod', @model.id)

