# ----- PubSub Events -----

BB.pubSubDestroyEvents = (data) ->
  modelId = data.eventid
  model = BB.Collections.events.get(modelId)
  userId   = data.userid
  user     = BB.members.get(userId)
  userName = user.shortName()
  BB.Collections.events.remove(model)
  BB.Collections.filteredEvents.reFilter()
  toastr.info "Event ##{modelId} has been deleted by #{userName}"

BB.pubSubAddEvents = (data) =>
  data.params.pubSub = {action: data.action, userid: data.userid}
  model = new BB.Models.Event(data.params)
  model.set(id: data.eventid)
  BB.Collections.events.add(model)
  BB.Collections.filteredEvents.reFilter()

BB.pubSubUpdateEvents = (data) =>
  modelId = data.eventid
  delete(data.params.isActive)
  data.params.pubSub = {action: data.action, userid: data.userid}
  model = BB.Collections.events.get(modelId)
  model.set(data.params)

BB.pubSubEvents = (data) ->
  jsData = JSON.parse(data)
  return if jsData["sessionid"] == sessionId
  switch jsData.action
    when "add"     then BB.pubSubAddEvents(jsData)
    when "update"  then BB.pubSubUpdateEvents(jsData)
    when "destroy" then BB.pubSubDestroyEvents(jsData)

