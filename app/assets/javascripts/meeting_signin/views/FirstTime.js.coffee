class BB.Views.FirstTime extends BB.Views.Content

  # ----- configuration -----

  initialize: (meetingId) ->
    @meetingId = meetingId
    @setupMeetingAndPeriod(meetingId)
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

  completeFunc: (ev, xhr) =>
    switch xhr.status
      when 201
        newMember = new BB.Models.Member(JSON.parse(xhr.responseText))
        BB.members.add(newMember)
        @addParticipant(newMember.get('id'))
        $('#errorMsg').hide()
        $('#inputForm').hide()
        $('#successMsg').text('You have been added!').show()
      when 200
        $('#errorMsg').hide()
      else
        errors   = JSON.parse(xhr.responseText).errors
        errorMsg = "#{errors?.join(', ')}. <u>Please try again.</u><br/>"
        $('#errorMsg').html(errorMsg).css('color', 'red').css('font-size' : '8pt')

  saveGuest: (ev) =>
    ev?.preventDefault()
    guestOpts = new BB.GuestOpts
    guestOpts.setName($('#name').val())
    guestOpts.setEmail($('#email').val())
    guestOpts.setPhone($('#cell').val())
    guestOpts.setZip($('#zip').val())
    guestOpts.createGuest((ev, xhr) => @completeFunc(ev, xhr))




