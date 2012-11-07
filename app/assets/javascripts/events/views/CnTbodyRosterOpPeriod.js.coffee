class BB.Views.CnTbodyRosterOpPeriod extends Backbone.Marionette.ItemView

  # ----- configuration -----

  template: 'events/templates/CnTbodyRosterOpPeriod'

  templateHelpers: -> BB.Helpers.CnTbodyRosterOpPeriodHelpers

  # ----- initialization -----

  initialize: (options) ->
    @model      = options.model           # Period
    @collection = @model.participants     # Participants
    @collection.fetch() if @collection.url.search('undefined') == -1
    @bindTo(@collection, 'add remove reset', @setSearchBox, this)
    @faye = new Faye.Client(faye_server)
    @subscription = @faye.subscribe("/periods/#{@model.id}/participants", (data) => @pubSubParticipants(data))
    @bindTo(BB.vent, 'cmd:ToggleAddParticipant',  @toggleAddParticipant,    this)
    @memberField = "#memberField#{@model.id}"
    @guestLink   = "#createGuestLink#{@model.id}"

  events:
    'click .deletePeriod'    : 'deletePeriod'
    'blur .memberField'      : 'onBlurSearch'
    'keyup .memberField'     : 'toggleGuestLink'
    'focus .memberField'     : 'onFocusSearch'
    'click .createGuestLink' : 'createGuest'

  onShow: ->
    @$el.css('font-size', '8pt')
    @$el.find('.tablesorter').tablesorter()
    @$el.find('.tablesorter td, .tablesorter th').css('font-size', '8pt')
    opts = {model: @model, collection: @collection}
    new BB.Views.CnTbodyRosterOpParticipants(opts).render()

  # ----- guest links -----

  showGuestLink: ->
    @$el.find(@guestLink).show()

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
      period_id: periodId
      member_id: memberId
      newMember: true
    participant = new BB.Models.Participant(opts)
    participant.urlRoot = "/eapi/periods/#{@model.get('id')}/participants"
    participant.save()
    @collection.add(participant)

  # ----- delete period -----

  deletePeriod: (ev) ->
    ev?.preventDefault()
    @model.destroy()

  # ----- PubSub Participants -----

  pubSubDestroyParticipant: (data) ->
    participantId = data.participantid
    participant = @collection.get(participantId)
    partMem = BB.members.get(participant.get('member_id'))
    userId   = data.userid
    user     = BB.members.get(userId)
    userName = user.fullName()
    @collection.remove(participant)
    toastr.info "#{partMem.shortName()} has been removed by #{userName}"

  pubSubAddParticipant: (data) =>
    data.params.pubSub = {action: data.action, userid: data.userid}
    model = new BB.Models.Participant(data.params)
    model.set(id: data.participantid)
    @collection.add(model)

  pubSubUpdateParticipant: (data) =>
    modelId = data.eventid
    delete(data.params.isActive)
    data.params.pubSub = {action: data.action, userid: data.userid}
    model = BB.Collections.events.get(modelId)
    model.set(data.params)

  pubSubParticipants: (data) ->
    jsData = JSON.parse(data)
    return if jsData["sessionid"] == sessionId
    switch jsData.action
      when "add"     then @pubSubAddParticipant(jsData)
      when "update"  then @pubSubUpdateParticipant(jsData)
      when "destroy" then @pubSubDestroyParticipant(jsData)