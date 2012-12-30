class BB.Views.Returning extends BB.Views.Content

  # ----- configuration -----

  template: 'meeting_signin/templates/Returning'

  initialize: (meetingId) ->
    @meetingId    = meetingId
    @meeting      = BB.meetings.get(@meetingId)
    @period       = @meeting.periods.first()
    @participants = @period.participants

  events:
    "change #takePhoto" : "displaySelectedImage"

  # ----- initialization -----

  onRender: ->
    @setFooter   "returning", @meetingId
    @setHomeLink "returning", @meetingId
    @setLabel    "returning"
    setTimeout(@initializePage, 1)
    @setupAutoComplete()
    $('#autoComp').focus()

  # ----- local methods -----

  setupAutoComplete: ->
    autoOpts =
      source: BB.members.autoCompleteRoster()
      minLength: 3
      select: (event, ui) => @autoCompleteAddParticipant(ui.item.memberId)
    @$el.find('#autoComp').autocomplete(autoOpts)

  autoCompleteAddParticipant: (memberId) ->
    console.log "MEMBERID Has been added!!", memberId
    member = BB.members.get(memberId)
    oldParticipant = @participants.select (member) -> member.get('member_id') == memberId
    console.log "OLD", oldParticipant
    if oldParticipant.length == 0
      console.log "ADDING NEW PART"
      participant = new BB.Models.Participant({member_id: memberId, period_id: @period.get('id')})
      participant.urlRoot = "/eapi/periods/#{@period.get('id')}/participants"
      participant.save()
      @participants.add(participant)
    $('#autoComp').hide()
    welcomeText = """
    <b>Welcome #{member.get('first_name')}!</b>
    <p></p>
    You are signed in.
    <div class='askPhoto' style='display: none;'>
      <p></p>
      </i>You have not uploaded a profile photo!</i>
    </div>
    <p></p>
    <div class='askPhoto' style='display: none;'>
      <a class='clickHome nav center-text' href='/meeting_signin/#{@meetingId}' data-id='#{@meetingId}'>Take a Profile Photo</a>
    </div>
    <a class='clickHome nav center-text' href='/meeting_signin/#{@meetingId}' data-id='#{@meetingId}'>Return Home</a>
    """
    $('#welcomeText').html(welcomeText).show()
    $('.askPhoto').show() unless member.hasPhoto()
    setTimeout(@setHeight,  1)
    setTimeout(@hideUrlBar, 5)

  displaySelectedImage: (ev) =>
    ev?.preventDefault()
#    console.log "TKP", $('#takePhoto')[0].files
#    return
    file = $('#takePhoto')[0].files[0]
    reader = new FileReader()
    reader.onload = (event) =>
      @displayCropSource(event)
#      displayCropThumb(event)
#      setTimeout(setupJcrop, 250)
    reader.readAsDataURL file
#    $('#uploadBtn').show()

  displayCropSource: (event) ->
    console.log "DCS"
    baseImg = new Image()
    baseImg.id  = "cropImg"
    baseImg.src = event.target.result
    imgHolder = $('#imgHolder')[0]
    imgHolder.innerHTML = ""
    imgHolder.appendChild baseImg