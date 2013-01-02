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
    @setHomeLink "first_time", @meetingId
    @setLabel    "first_time"
    setTimeout(@initializePage, 1)

  # ----- local methods -----

  saveGuest: (ev) ->
    ev?.preventDefault()
    guestOpts = new BB.GuestOpts
    guestOpts.setName($('#name').val())
    guestOpts.setEmail($('#email').val())
    guestOpts.setPhone($('#cell').val())
    guestOpts.setZip($('#zip').val())
    guestOpts.createGuest()




