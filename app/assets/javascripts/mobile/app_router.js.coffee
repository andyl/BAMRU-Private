BB.Routers.AppRouter = Backbone.Marionette.AppRouter.extend

  routes :
    "mobile"               : "index"
    "mobile/"              : "index"
    "mobile/members"       : "members"
    "mobile/members/:id"   : "member"
    "mobile/status"        : "status"
    "mobile/page"          : "page"
    "mobile/page_select"   : "page_select"
    "mobile/page_send"     : "page_send"
    "mobile/messages"      : "messages"
    "mobile/messages/:id"  : "message"
    "mobile/inbox"         : "inbox"
    "mobile/profile"       : "profile"
    "mobile/location"      : "location"
    "mobile/events"        : "events"
    "mobile/events/:id"    : "event"
    'meeting_signin/*path' : "default"

  initialize: ->
    # ----- faye -----
#    BB.PubSub.events = new BB.PubSub.Events(BB.Collections.events)
    # ----- create app layout -----
    BB.Views.appBody = new BB.Views.AppBody()
    @appBody = BB.Views.appBody
    @appBody.render()

  index: ->
    console.log "rendering index"
    $('.clickHome').hide()
    @appBody.content.show(new BB.Views.Index)

  members: ->
    console.log "rendering members"
    @appBody.content.show(new BB.Views.Members)

  member: (id) ->
    console.log "rendering member for #{id}"
    @appBody.content.show(new BB.Views.Member(id))

  first_time: (id) ->
    console.log "rendering first_time for #{id}"
#    @_render(id, new BB.Views.FirstTime(id))

  returning: (id) ->
    console.log "rendering returning for #{id}"
#    @_render(id, new BB.Views.Returning(id))

  roster: (id) ->
    console.log "rendering roster for #{id}"
#    @_render(id, new BB.Views.Roster(id))

  photo: (meetingId, memberId) ->
    console.log "rendering photo for #{meetingId} and member #{memberId}"
#    @_render(meetingId, new BB.Views.Photo(meetingId, memberId))

  default: ->
    console.log "rendering the default route"
#    @appBody.render().content.show(new BB.Views.Unrecognized)

#  _missingEventMsg: (id) ->
#    if BB.Collections.events.get(id)
#      "Event is in the datbase but not in the filtered list."
#    else
#      "Event is not in the database."
      
#  _showMissingEvent: (id) ->
#    msg = @_missingEventMsg(id)
#    @appBody.content.show(new BB.Views.CnMissingEvent({eventId: id, missingEventMessage: msg}))
    
#  _render: (id, view) ->
#    if BB.meetings.get(id)
#      @appBody.render().content.show(view)
#    else
#      @appBody.render().content.show(new BB.Views.Unrecognized("Unknown Meeting (ID ##{id})"))
