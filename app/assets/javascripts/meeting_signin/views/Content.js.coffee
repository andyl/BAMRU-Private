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
      when "first_time"  then @footerMenu(meetingId)
      when "returning"   then @footerMenu(meetingId)
      when "roster"      then @meetingLink()
      else ""

  setFooter: (page, meetingId) ->
    $('#footer').html(@footerHtml(page, meetingId))
    $('#footer').trigger('change')

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
      when "index", "home" then "BAMRU Meeting Sign In"
      when "first_time"    then "First Time Guest"
      when "returning"     then "Returning Attendee"
      when "roster"        then "Roster"
      else "Meeting Sign Up"
    $('#label').text(text)



  # --------------------------------
  # ----- initialize the stuff -----
  # --------------------------------

#  template: 'events/templates/CnTbodyRosterMt'
#
#  regions:
#    period: '#period'
#
#  # ----- initialization -----
#
#  initialize: (options) ->
#    @model      = options.model     # Event
#    @collection = @model.periods    # Periods
#
#  onShow: ->
#    opts =
#      success: => @afterFetch()
#    @collection.fetch(opts)
#
#  # ----- methods -----
#
#  afterFetch: ->
#    if @collection.length == 0
#      opts =
#        success: => @createPeriod()
#      @createPeriod(opts)
#    else
#      @showPeriod()
#
#  showPeriod: ->
#    periodModel = @collection.first()
#    periodView  = new BB.Views.CnTbodyRosterMtPeriod({model: periodModel})
#    @period.show(periodView) unless @period == undefined
#
#  createPeriod: ->
#    opts =
#      event_id: @model.get('id')
#    period = new BB.Models.Period(opts)
#    period.urlRoot = "/eapi/events/#{@model.get('id')}/periods"
#    opts =
#      success: => @collection.add(period); @showPeriod()
#    period.save({}, opts)