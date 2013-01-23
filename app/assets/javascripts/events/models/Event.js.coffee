class BB.Models.Event extends Backbone.Model

  # ----- configuration -----

  urlRoot: '/eapi/events'

  defaults: ->
    "start"    : moment().strftime("%Y-%m-%d")
    "title"    : "TBA"
    "leaders"  : "TBA"
    "location" : "TBA"
    "all_day"  : true
    "published": false

  # ----- initialization -----

  initialize: ->
    @eventLinks     = new BB.Collections.EventLinks()
    @eventPhotos    = new BB.Collections.EventPhotos()
    @eventFiles     = new BB.Collections.EventFiles()
    @eventReports   = new BB.Collections.EventReports()
    @periods        = new BB.Collections.Periods()
    @updateCollectionUrls()
    @bind("change:id", @updateCollectionUrls)
    @updateDerivedDates()
    baseDates    = "change:start change:finish"
    @bind(baseDates,    @updateDerivedDates)
#    @bind(baseDates,    @updateDateOrder)

  updateCollectionUrls: ->
    @eventLinks.url   = "/eapi/events/#{@.id}/event_links"
    @eventPhotos.url  = "/eapi/events/#{@.id}/event_photos"
    @eventFiles.url   = "/eapi/events/#{@.id}/event_files"
    @eventReports.url = "/eapi/events/#{@.id}/event_reports"
    @periods.url      = "/eapi/events/#{@.id}/periods"

  # ----- instance methods : Dates -----

#  updateDateOrder: ->
#    start  = @get('start')
#    finish = @get('finish')
#    allDay = @get('all_day')
#    return if finish == null
#    return if finish == undefined
#    return if finish == ""
#    console.log "REVERSING", start, finish
#    @set({start: finish, finish: start}) if start > finish
#    @set({finish: ""}) if start == finish

  updateDerivedDates: ->
    console.log "UDD"
    opts = {}
    [opts.startDate,  opts.startTime]  = @get('start')?.split(' ')  || [null, null]
    [opts.finishDate, opts.finishTime] = @get('finish')?.split(' ') || [null, null]
    @set(opts, {silent: true})

  updateBaseDates: ->
    [start, finish] = ["", ""]
    if @get('all_day')
      start = @get('startDate')
      finish = @get('finishDate')
    else
      start  = "#{@get('startDate')} #{@get('startTime')}"
      finish = "#{@get('finishDate')} #{@get('finishTime')}"
    @set({startDate:'', startTime:'', finishDate:'', finishTime:''})
    console.log "BAS", start,  "|", finish
    if finish.length < 8
      @set({start: start, finish: "", all_day: true})
      return
    @set({start: finish, finish: start}) if start > finish
    @set({start: start, finish: "", all_day: true}) if start == finish
    @set({start: start, finish: finish}) if start < finish

  # ----- instance methods -----

  rowPub:   -> if @get('published') then "+" else "~"
  rowTyp:   -> @get('typ')[0].toUpperCase()
  rowTitle: -> _.string.truncate(@get('title'), 12)
  rowLoc:   -> _.string.truncate(@get('location'), 12)
  rowStart: -> moment(@get('start'))?.strftime("%Y-%m-%d")

  rowText: ->
    "#{@rowPub()} #{@rowTyp()} #{@rowTitle()} #{@rowLoc()} #{@rowStart()}"
