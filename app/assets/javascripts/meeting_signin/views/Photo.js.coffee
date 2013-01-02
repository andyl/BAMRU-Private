class BB.Views.Photo extends BB.Views.Content

  # ----- configuration -----

  template: 'meeting_signin/templates/Photo'

  initialize: (meetingId) ->
    @meetingId    = meetingId
#    @meeting      = BB.meetings.get(@meetingId)
#    @period       = @meeting.periods.first()
#    @participants = @period.participants
#    window.rosCtx = this
#    @jcrop_api = undefined
#    @boundx    = undefined
#    @boundy    = undefined

  events:
    "click  #photoClick" : "genPhotoFile"
    "change #takePhoto"  : "displaySelectedImage"
    "click  #cropShrink" : "cropShrink"
    "click  #cropGrow"   : "cropGrow"

  # ----- initialization -----

  onRender: ->
    @setHomeLink "returning", @meetingId
    @setLabel    "returning"
    setTimeout(@initializePage, 1)
#    @setupAutoComplete()
#    $('#autoComp').focus()

  # ----- local methods -----

  setupAutoComplete: ->
    autoOpts =
      source: BB.members.autoCompleteRoster()
      minLength: 3
      select: (event, ui) => @autoCompleteAddParticipant(ui.item.memberId)
    @$el.find('#autoComp').autocomplete(autoOpts)

  autoCompleteAddParticipant: (memberId) ->
    member = BB.members.get(memberId)
    oldParticipant = @participants.select (member) -> member.get('member_id') == memberId
    if oldParticipant.length == 0
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
      <b>You have not uploaded a profile photo!</b>
    </div>
    <p></p>
    <div class='askPhoto' style='display: none;'>
      <a id='photoClick' class='nav center-text' href='#'>Take a Profile Photo</a>
    </div>
    <a class='clickHome nav center-text' href='/meeting_signin/#{@meetingId}' data-id='#{@meetingId}'>Return Home</a>
    """
    $('#welcomeText').html(welcomeText).show()
    $('.askPhoto').show() unless member.hasPhoto()
    setTimeout(@setHeight,  1)
    setTimeout(@hideUrlBar, 5)

  setPhotoButtons: ->
    text = """
      <a id='photoClick' class='nav center-text' href='#'>Retake</a>
      <a id='photoClick' class='nav center-text' href='#'>Save</a>
      <a class='clickHome nav center-text' href='/meeting_signin/#{@meetingId}' data-id='#{@meetingId}'>Cancel</a>
    """
    $('#photoButtons').html(text)

  displaySelectedImage: (ev) =>
    ev?.preventDefault()
    file = $('#takePhoto')[0].files[0]
    reader = new FileReader()
    reader.onload = (event) =>
      @displayCropSource(event)
      setTimeout(@displayCropThumb, 200, event)
      setTimeout(@setupJcrop, 400)
    reader.readAsDataURL file
    @setPhotoButtons()
#    $('#uploadBtn').show()

  displayCropSource: (event) ->
    baseImg = new Image()
    baseImg.id  = "cropImg"
    baseImg.src = event.target.result
    $(baseImg).css('max-height', '200px')
    imgHolder = $('#imgHolder')[0]
    imgHolder.innerHTML = ""
    imgHolder.appendChild baseImg

  displayCropThumb: (event) ->
    prevImg = new Image()
    prevImg.id = "imgPreview"
    prevImg.src = event.target.result
    $('#imgPreviewDiv').html("")
    $('#imgPreviewDiv').append(prevImg)

  setupJcrop: ->
    opts =
      boxWidth:  370
      boxHeight: 300
      onChange: rosCtx.updatePreview
      onSelect: rosCtx.updatePreview
      aspectRatio: 4/3
      allowResize: false
      allowSelect: false
      minSize: [50,50]
      setSelect: [10,10,250,190]
    $("#cropImg").Jcrop opts, ->
      bounds = @getBounds()
      rosCtx.boundx = bounds[0]
      rosCtx.boundy = bounds[1]
      rosCtx.jcrop_api = this
      setTimeout(rosCtx.initUpdate, 1)

  cropShrink: (ev) ->
    ev?.preventDefault()
    coords = rosCtx.jcrop_api.tellSelect()
    return if Math.round(coords.w) < 40
    newX1 = Math.round(coords.x) + 2
    newY1 = Math.round(coords.y)
    newX2 = Math.round(coords.x2) - 2
    newY2 = Math.round(coords.y2) - 3
    rosCtx.jcrop_api.animateTo([newX1, newY1, newX2, newY2])

  cropGrow: (ev) ->
    ev?.preventDefault()
    coords = rosCtx.jcrop_api.tellSelect()
    newX1 = Math.round(coords.x) - 2
    newY1 = Math.round(coords.y)
    newX2 = Math.round(coords.x2) + 2
    newY2 = Math.round(coords.y2) + 3
    rosCtx.jcrop_api.animateTo([newX1, newY1, newX2, newY2])

  initUpdate: =>
    initCoords =
      x: 10
      y: 10
      w: 240
      h: 180
    @.updatePreview(initCoords)
    $('#loadingMsg').hide()
    $('#imgHolder').show()
    $('.xResize').show()

  updatePreview: (coords) ->
    window.coords = coords
    if parseInt(coords.w) > 0
      rx = 120 / coords.w
      ry = 90  / coords.h
      d = {}
      d.Width  = Math.round(rx * rosCtx.boundx) + "px"
      d.Height = Math.round(ry * rosCtx.boundy) + "px"
      d.MarginLeft = "-" + Math.round(rx * coords.x) + "px"
      d.MarginTop  = "-" + Math.round(ry * coords.y) + "px"
      $("#imgPreview").css
        width:  d.Width
        height: d.Height
        marginLeft: d.MarginLeft
        marginTop:  d.MarginTop

  genPhotoFile: (ev) ->
    ev?.preventDefault()
    $('#welcomeText').hide()
    $('#takePhoto').click()
