# ----- PubSub Events -----

BB.PubSub = {}

class BB.PubSub.Base

  # ----- object creation and destruction -----

  constructor: (@collection) ->
    @faye         = new Faye.Client(faye_server)
    @channel      = @collection.url
    @subscription = @faye.subscribe(@channel, (data) => @receive(data))

  close: -> @subscription.cancel()

  # ----- 'flash' notifications -----

  showMsg: (message) -> toastr.info(message)

  _setMsgFields: (model) ->
    @modelId   = model.id
    @userId    = model.get('pubSub').userid
    @user      = BB.members.get(@userId)
    @userName  = @user.fullName()
    @setMsgFields(model)

  _addMsg:      (model) -> @_setMsgFields(model) ; @addMsg()
  _updateMsg:   (model) -> @_setMsgFields(model) ; @updateMsg()
  _destroyMsg:  (model) -> @_setMsgFields(model) ; @destroyMsg()

  # ----- clear highlight from model -----

  removeHighLight: (model) ->
    clearHighLight = =>
      model.unset('pubSub')
      model.unset('newMember')
    setTimeout(clearHighLight, 3000)

  # ----- event handlers -----

  add :(data) ->
    data.params.pubSub = {action: data.action, userid: data.userid}
    model = new @collection.model(data.params)
    model.set(id: data.modelid)
    @collection.add(model)
    @afterAdd()
    @showMsg @_addMsg(model)
    @removeHighLight(model)

  update : (data) ->
    modelId = data.modelid
    delete(data.params.isActive)
    data.params.pubSub = {action: data.action, userid: data.userid}
    model = @collection.get(modelId)
    model.set(data.params)
    @showMsg @_updateMsg(model)
    @removeHighLight(model)

  destroy : (data) ->
    modelId = data.modelid
    model   = @collection.get(modelId)
    @collection.remove(model)
    model.set(pubSub: {action: data.action, userid: data.userid})
    @afterDestroy()
    @showMsg @_destroyMsg(model)

  receive : (data) ->
    jsData = JSON.parse(data)
    return if jsData["sessionid"] == sessionId
    switch jsData.action
      when "add"     then @add(jsData)
      when "update"  then @update(jsData)
      when "destroy" then @destroy(jsData)

  # ----- template methods: event handling -----
  afterAdd:     -> "template method..."
  afterDestroy: -> "template method..."

  # ----- template methods: 'flash' notifications -----
  setMsgFields: (model) -> "template method..."

  addMsg:       -> "Item ##{@modelId} added by #{@userName}"
  updateMsg:    -> "Item ##{@modelId} updated by #{@userName}"
  destroyMsg:   -> "Item ##{@modelId} deleted by #{@userName}"

class BB.PubSub.Events extends BB.PubSub.Base
  afterAdd:     -> BB.Collections.filteredEvents.reFilter()
  afterDestroy: -> BB.Collections.filteredEvents.reFilter()
