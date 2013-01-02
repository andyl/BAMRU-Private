class BB.Views.Content extends Backbone.Marionette.ItemView

  events:
    "touchend" : "checkUrlBar"

  # ----- initialize page -----

  initializePage: =>
    @setPageHeight()
    @checkUrlBar()
  
  # ----- page height / setting the footer at the page bottom -----

  setPageHeight: =>
    @baseHeight = $('.wrapper').height()
    @setHeight()
    $(window).resize    => @setHeight()
    $('#footer').change => @setHeight()

  setHeight: ->
    windowHeight  = $(window).height()
    windowHeight  = $(window).height()
    wrapperHeight = $('.wrapper').height()
    footerHeight  = $('#footer').height()
    if (@baseHeight + footerHeight) < windowHeight
      tgtHeight = windowHeight - (footerHeight * 2) - 1
      $('.wrapper').height(tgtHeight)
    else
      $('.wrapper').css('height', '100%')
    $('#footer').show()

  # ----- hiding the URL Bar -----

  hideUrlBar: ->
    bh = $('body').height()
    wh = $(window).height()
    spacerHeight = wh - bh + 55
    if wh >= bh
      $('#spacer').show().height(spacerHeight)
    window.scrollTo(0,1)

  checkUrlBar: =>
    return unless BB.isPhone
    offset = window.pageYOffset;
    if offset < 100
      @hideUrlBar()
      @setHeight()

  # ----- footer rendering -----

  meetingLink: ->
    "<a id='meetings' class='navLink' href='/meeting_signin'  data-typ='meetings'>Meetings</a>"

  rosterLink: (meetingId) ->
    "<a id='roster' class='navLink' href='/meeting_signin/#{meetingId}/roster' data-typ='roster' data-id='#{meetingId}'>Roster</a>"

  footerMenu: (meetingId) ->
    "#{@meetingLink()}<span style='margin-left: 60px;'> </span>#{@rosterLink(meetingId)}"

  footerHtml: (page, meetingId) ->
    switch page
      when "home"        then @footerMenu(meetingId)
      else ""

  setFooter: (page, meetingId) ->
    $('#footer').html(@footerHtml(page, meetingId))
    $('#footer').trigger('change')

  # ----- meeting / period initialize -----

  setupMeetingAndPeriod: (meetingId) ->
    @meeting      = BB.meetings.get(meetingId)
    @period       = @meeting.periods.first()
    if @period?
      @participants = @period.participants
    else
      initFunc = =>
        @period = @meeting.periods.first()
        @participants = @period.participants
      setTimeout(initFunc, 500)

  addParticipant: (memberId) ->
    member = BB.members.get(memberId)
    oldParticipant = @participants.select (member) -> member.get('member_id') == memberId
    if oldParticipant.length == 0
      participant = new BB.Models.Participant({member_id: memberId, period_id: @period.get('id')})
      participant.urlRoot = "/eapi/periods/#{@period.get('id')}/participants"
      participant.save()
      @participants.add(participant)
    member

  # ----- header rendering -----

  homeLink: (id) ->
    "<a class='clickHome back' data-id='#{id}' href='/meeting_signin/#{id}'>Home</a>"

  setHomeLink: (page, meetingId) ->
    html = switch page
      when "first_time", "returning", "roster"
        @homeLink(meetingId)
      else ""
    $('#homeLink').html(html)

  # ------ label -----

  setLabel: (page) ->
    text = switch page
      when "index", "home" then "Meeting Sign In"
      when "first_time"    then "First Time Guest"
      when "returning"     then "Returning Attendee"
      when "roster"        then "Roster"
      when "photo"         then "Photo"
      else "Meeting Sign Up"
    $('#label').text(text)

