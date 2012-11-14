class BB.Views.SidebarList extends Backbone.Marionette.CollectionView

  # ----- configuration -----

  el       : "#sidebar-tbody"
  itemView : BB.Views.SidebarRow

  # ----- initialization -----

  initialize: (options) ->
    @bindTo(BB.vent,     'show:CnTabs',         @setActive,   this)
    @bindTo(BB.vent,     'show:CnIndx',         @clearActive, this)
    @bindTo(BB.vent,     'show:CnNew',          @clearActive, this)
    @bindTo(BB.vent,     'key:nextRow',         @nextRow,     this)
    @bindTo(BB.vent,     'key:prevRow',         @prevRow,     this)
    @bindTo(BB.vent,     'key:topRow',          @topRow,      this)
    @bindTo(BB.vent,     'key:bottomRow',       @bottomRow,   this)
    @bindTo(BB.vent,     'uiState:changed',     @updateView,  this)

  onRender: ->
    $('#myTable').show()
    @setMyTable()
    BB.hotKeys.enable("SidebarList")
    @openSidebar()

  onClose: ->
    BB.hotKeys.disable("SidebarList")

  # ----- construction -----

  appendHtml: (collectionView, itemView, index) ->
    collectionView.$el.append(itemView.el)

  # ----- selecting active event -----

  setActive: (m) ->
    BB.Collections.events.setActive(m.id)

  updateView: (model) ->
    BB.Collections.filteredEvents.filter(model.toJSON())

  clearActive: ->
    BB.Collections.events.clearActive()

  # ----- up/down event navigation -----

  nextRow: -> @altRow "next"

  prevRow: -> @altRow "prev"

  openSidebar: ->
    BB.vent.trigger "key:OpenSidebar"

  displayRow: (targetRow, direction = "none") ->
    targetId = $(targetRow).attr('id').split('_')[1]
    if targetId != activeModel?.get('id')
      @scrollRow(targetRow, direction)
      @collection.setActive(targetId)
      BB.Routers.app.navigate("/events/#{targetId}", {trigger: true})
      @openSidebar()

  altRow: (direction) ->
    firstRow =         => $(@$el.find("tr")[0])
    isHidden =   (row) => row.length == 0
    endOfTable = (row) => row.length == 0
    activeModel = @collection.getActive()[0]
    targetRow = if activeModel?
      activeRow = $("#model_#{activeModel.get('id')}")
      if isHidden(activeRow)
        firstRow()[0]
      else
        altRow = eval("activeRow.#{direction}()")
        if endOfTable(altRow) then activeRow[0] else altRow[0]
    else
      firstRow()[0]
    @displayRow(targetRow, direction)

  topRow: ->
    firstRow = => $(@$el.find("tr")[0])
    @displayRow(firstRow()[0])

  bottomRow: ->
    bottomRow = => $(@$el.find("tr:last"))
    @displayRow(bottomRow()[0])
    @pullToTop(bottomRow()[0])

  tableLength:    => @$el.find("tr").length

  # ----- scrolling -----

  position:     (row) => @$el.find("tr").index(row)
  inTopFive:    (row) => @position(row) < 2
  inBottomFive: (row) => @position(row) > @tableLength() - 2
  threeAbove:   (row) => $(@$el.find("tr")[@position(row) - 1])
  threeBelow:   (row) => $(@$el.find("tr")[@position(row) + 1])

  pullToBottom : (row) => row.scrollIntoView(false)
  pullToTop    : (row) => row.scrollIntoView()

  scrollRow: (targetRow, direction) ->
    if @inTopFive(targetRow)
      @pullToBottom(targetRow)
      return
    if @inBottomFive(targetRow)
      @pullToTop(targetRow)
      return
    switch direction
      when "none" then @pullToBottom(targetRow)
      when "prev"
        if @isIn(targetRow)
          @doPrev(targetRow)
        else
          if @isAbove(targetRow)
            @doAbovePrev(targetRow)
          else
            @doBelowPrev(targetRow)
      when "next"
        if @isIn(targetRow)
          @doNext(targetRow)
        else
          if @isAbove(targetRow)
            @doAboveNext(targetRow)
          else
            @doBelowNext(targetRow)

  doAbovePrev: (targetRow) ->
    @pullToTop(@threeAbove(targetRow)[0])
  doBelowPrev: (targetRow) ->
    @pullToBottom(@threeBelow(targetRow)[0])
  doPrev: (targetRow) ->
    aboveRow = @threeAbove(targetRow)
    @pullToTop(aboveRow[0]) if @isAbove(aboveRow)

  doAboveNext: (targetRow) ->
    @pullToTop(@threeAbove(targetRow)[0])
  doBelowNext: (targetRow) ->
    @pullToBottom(@threeBelow(targetRow)[0])
  doNext: (targetRow) ->
    belowRow = @threeBelow(targetRow)
    @pullToBottom(belowRow[0]) if @isBelow(belowRow)

  _bottom: (el) -> $(el).offset().top + $(el).height()
  _top: (el) -> $(el).offset().top

  div: '.ui-layout-west'

  isBelow: (element) -> @_bottom(@div) < @_bottom(element)
  isAbove: (element) -> @_top(@div) > @_top(element)
  isIn: (element) -> @_top(@div) < @_top(element) && @_bottom(@div) > @_bottom(element)
  isOut: (element) -> ! @isIn(element)

  # ----- filtering -----

  filterParams:
    filterContainer:      "#filter-box"
    filterColumns:        [0,1,2,3]
    columns:              ["typ", "title", "location", "start"]

  setupFilter: ->
    $("#myTable").tablesorterFilter(@filterParams)
    $("#filterClearButton").click ->
      $("#filter-box").val('')
      $("#filter-box").trigger("keyup")
      $("#filter-box").blur()
    $("#filter-box").keyup ->
      setTimeout('', 750)

  # ----- sorting -----

  typ_score_options:
    id:     'typ_score'                             # the parser name
    is:     (type) -> false                         # disable standard parser
    type:   'numeric'                               # either text or numeric
    format: (type) ->                               # the sort key (typ score)
      return 0 unless type?
      switch type.toUpperCase()[0]
        when "M"  then -10
        when "T"  then -20
        when "O"  then -30
        when "C"  then -40
        when "S"  then -50

  sort_opts:
    headers:
      0: {sorter: 'typ_score'}    # sort col 0 using typ_score options

  saveEventSortToCookie: (sort_spec) ->
    spec_string = JSON.stringify(sort_spec)
    createCookie("event_sort", spec_string, 45)

  readEventSortFromCookie: ->
    string = readCookie("event_sort")
    if (string == null) then null else JSON.parse(string)

  setupSorter: ->
    $.tablesorter.addParser @typ_score_options
    sort_spec = @readEventSortFromCookie()
    @sort_opts['sortList'] = sort_spec unless sort_spec == null
    $("#myTable").tablesorter(@sort_opts).bind "sortEnd", (sorter) =>
      @saveEventSortToCookie(sorter.target.config.sortList)

  resetSorter: ->
    sort_spec = @readEventSortFromCookie()
    $('#myTable').trigger('update')
    $('#myTable').trigger('sorton', [sort_spec]) unless sort_spec == null
    $('#filter-box').val('')
    $('#filter-box').blur()

  setMyTable: ->
    if $('#myTable tr').length > 1
      if $('#myTable th:first').css('background-image') == "none"
        @setupSorter()
        @setupFilter()
      else
        @resetSorter()
        @setupFilter()
