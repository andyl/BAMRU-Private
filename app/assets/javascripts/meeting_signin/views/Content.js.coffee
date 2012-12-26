class BB.Views.Content extends Backbone.Marionette.ItemView

  events:
    "touchend" : "checkUrlBar"

  # ----- initialize page -----

  initializePage: =>
    @setPageHeight()
    @checkUrlBar()
  
  # ----- page height / setting the footer at the bottom of the page -----

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
      console.log "BBB", @baseHeight, footerHeight
      tgtHeight = windowHeight - (footerHeight * 2) - 1
      $('.wrapper').height(tgtHeight)
    else
      console.log "HOHO"
      $('.wrapper').css('height', '100%')
    $('#footer').show()

  # ----- hiding the URL Bar -----

  hideUrlBar: ->
    bh = $('body').height()
    wh = $(window).height()
    spacerHeight = wh - bh + 55
    console.log "hiding", wh, bh, spacerHeight
    if wh >= bh
      console.log "setting"
      $('#spacer').show().height(spacerHeight)
    window.scrollTo(0,1)

  checkUrlBar: =>
    console.log "checking"
    return unless BB.isPhone
    offset = window.pageYOffset;
    console.log "CHECKING URL BAR", offset
    if offset < 100
      @hideUrlBar()
      @setHeight()

  # ----- footer rendering -----

  meetingLink: ->
    "<a id='meetings' class='navLink' href='/meeting_signin'  data-typ='meetings'>Meetings</a>"

  rosterLink: (meetingId) ->
    "<a id='roster' class='navLink' href='/meeting_signin/#{meetingId}/roster' data-typ='roster' data-id=234>Roster</a>"

  footerMenu: (meetingId) ->
    "#{@meetingLink()}<span style='margin-left: 60px;'> </span>#{@rosterLink(234)}"

  footerHtml: (page) ->
    switch page
      when "home"        then @footerMenu(234)
      when "first_time"  then @footerMenu(234)
      when "returning"   then @footerMenu(234)
      when "roster"      then @meetingLink()
      else ""

  setFooter: (page) ->
    $('#footer').html(@footerHtml(page))
    $('#footer').trigger('change')

  # ----- header rendering -----

  homeLink: (id) ->
    "<a class='clickHome back' href='/meeting_signin/#{id}'>Home</a>"

  setHomeLink: (page) ->
    html = switch page
      when "first_time", "returning", "roster"
        @homeLink(234)
      else ""
    $('#homeLink').html(html)

  # ------ label -----

  setLabel: (page) ->
    text = switch page
      when "index", "home" then "BAMRU Meeting Sign In"
      when "first_time"    then "First Time Guest"
      when "returning"     then "Returning Attendee"
      when "roster"        then "Roster"
      else "Meeting Sign Up"
    $('#label').text(text)

