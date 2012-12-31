class BB.Views.FirstTime extends BB.Views.Content

  # ----- configuration -----

  initialize: (meetingId) ->
    @meetingId = meetingId
    @model = new Backbone.Model()
    @model.set('meetingId': @meetingId)

  template: 'meeting_signin/templates/FirstTime'

  events:
    "click #saveGuest" : "saveGuest"


  # ----- initialization -----

  onRender: =>
    @setFooter   "first_time", @meetingId
    @setHomeLink "first_time", @meetingId
    @setLabel    "first_time"
    setTimeout(@initializePage, 1)

  # ----- local methods -----

  saveGuest: (ev) ->
    ev?.preventDefault()
    alert "Under Construction"
