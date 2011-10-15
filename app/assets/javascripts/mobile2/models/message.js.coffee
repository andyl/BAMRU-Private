#= require ./common_model

window.inbox = []

class @Message extends CommonModel
  initialize: ->
    obj = @
    if @has('distributions')
      @distributions = new Distributions @get('distributions')
      _(@distributions.models).each (dist) ->
        dist.set({'message': obj})
        window.inbox = window.inbox.concat(dist) if dist.get('member_id') == myid
  hasRSVP:      -> @has('rsvp_prompt')
  sentCount:    -> @distributions.models.length
  readCount:    ->
    val = _(@distributions.models).select (dist)->
      dist.get('read') == "yes"
    val.length
  unreadCount:  ->
    val = _(@distributions.models).select (dist)->
      dist.get('read') == "no"
    val.length
  rsvpYesCount: ->
    val = _(@distributions.models).select (dist)->
      dist.get('rsvp') == "yes"
    val.length
  rsvpNoCount:  ->
    val = _(@distributions.models).select (dist)->
      dist.get('rsvp') == "no"
    val.length