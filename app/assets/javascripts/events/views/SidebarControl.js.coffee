class BB.Views.SidebarControl extends Backbone.Marionette.ItemView

  # ----- configuration -----

  template:        'events/templates/SidebarControl'
  templateHelpers: BB.Helpers.SidebarControlHelpers

  # ----- initialization -----

  initialize: ->
    @bindTo(BB.Collections.events, 'remove',            @render,            this)
    @bindTo(BB.vent,     'cmd:ToggleCheckbox',          @toggleCheckbox,    this)
    @bindTo(BB.vent,     'cmd:ExclusiveCheckbox',       @exclusiveCheckbox, this)
    @bindTo(BB.vent,     'uiState:changed',             @updateControlBox,  this)
    @bindTo(BB.vent,     'cmd:SidebarFilterFocus',      @toggleFilterFocus, this)
    @bindTo(BB.vent,     'cmd:SidebarControlReset',     @reset,             this)
    @bindTo(BB.vent,     'cmd:SidebarControlNew',       @newEvent,          this)
    @bindTo(BB.vent,     'cmd:SidebarControlCheckAll',  @checkAll,          this)
    @bindTo(BB.vent,     'cmd:SidebarControlToggleAll', @toggleAll,         this)

  events:
    'change .typCk'            : 'updateView'
    'change .dateSel'          : 'updateView'
    'click #filterResetButton' : 'reset'
    'blur #filter-box'         : 'filterBlur'
    'focus #filter-box'        : 'filterFocus'
    'click #closeBox'          : 'blurSelectMenu'
    'blur #select-button'      : 'blurSelectMenu'
    'click #select-button'     : 'blurSelectMenu'
    'focus #typ-button'        : 'focusTypButton'
    'click #new-event-button'  : 'newEvent'

  onShow: ->
    BB.hotKeys.enable("SidebarControl")
    @updateControlBox()

  onClose: ->
    BB.hotKeys.disable("SidebarControl")

  newEvent: -> BB.Routers.app.navigate("/events/new", {trigger: true})

  # ----- uiState -----

  toggleCheckbox: (type) ->
    checkVal = if @model.get(type) then false else true
    typeObj = {}
    typeObj[type] = checkVal
    @model.set(typeObj)

  exclusiveCheckbox: (type) ->
    typeObj = @setAll false
    typeObj[type] = true
    @model.set(typeObj)

  checkBoxTypes: -> _.omit(@model.toJSON(), ['start', 'finish', 'true'])
  allChecked:    -> _.all(@checkBoxTypes(), (val, type) -> val)

  updateControlBox: ->
    # update checkboxes
    types = @checkBoxTypes()
    _.each(types, (val, type) -> $("##{type}-id").attr('checked',val))
    # update checkbox-button label
    label = if @allChecked()
      "All Types"
    else
      checked = reduceArr types, (acc, val, key) -> if val then acc.concat(key.toUpperCase()[0]) else acc
      if checked.length == 0 then "No Types" else "Type #{checked.join(',')}"
    $('#placeDisplay').html(label)
    $('#select-button').val(label)
    # update date select boxes
    esc = BB.Helpers.SidebarControlHelpers
    sOpt = esc.eventRangeSelect(@model.get('start'),  @model.get('finish'))
    fOpt = esc.eventRangeSelect(@model.get('finish'), @model.get('start'))
    $('#startSel').html(sOpt)
    $('#finishSel').html(fOpt)

  updateView: ->
    newFilter =
      start:      $('#startSel').val()
      finish:     $('#finishSel').val()
      meeting:    $('#meeting-id').is(':checked')
      training:   $('#training-id').is(':checked')
      operation:  $('#operation-id').is(':checked')
      community:  $('#community-id').is(':checked')
      social:     $('#social-id').is(':checked')
    oldFilter = @model.toJSON()
    mergeFilter = _.extend(oldFilter, newFilter)
    @model.validSet mergeFilter
    @model.stateChanged()

  reset: ->
    BB.UI.filterState.resetState()
    eraseCookie("event_sort")
    $('#myTable').trigger('sorton', [[]])

  allTypes: ["meeting", "training", "operation", "community", "social"]
  setAll: (val) -> reduceObj @allTypes, (acc, key) -> acc[key] = val; acc
  checkAll: (ev) ->
    ev?.preventDefault()
    console.log "CheckALL"
    @model.set(@setAll(true), {silent: true})
    BB.vent.trigger("uiState:changed", @model)
    @model.saveStateToLocalStorage()
  clearAll: (ev) ->
    ev?.preventDefault()
    console.log "ClearAll"
    @model.set(@setAll(false), {silent: true})
    BB.vent.trigger("uiState:changed", @model)
    @model.saveStateToLocalStorage()
  toggleAll: (ev) ->
    console.log "Toggle"
    if @allChecked() then @clearAll() else @checkAll()

  # ----- filter box -----

  toggleFilterFocus: ->
    toggle = ->
      if $('#filter-box').is(':focus')
        newVal = $('#filter-box').val().replace('/','')
        $('#filter-box').val(newVal)
        $('#filter-box').blur()
      else
        $('#filter-box').val('')
        $('#filter-box').focus()
    setTimeout(toggle, 100)

  filterBlur  : -> $('#filter-box').css('background', 'white')
  filterFocus : -> $('#filter-box').css('background', 'yellow')

  # ----- type checkbox -----

  blurSelectMenu : (event) ->
    event?.preventDefault()
    $('#select-menu, #select-button').hide()
    $('#typ-button').blur().show()
    $('body, .dateSel, #select-menu').unbind 'mousedown'
    $('#checkAll, #clearAll').unbind 'click'

  focusTypButton : (event) ->
    typH = $('#typ-button').height()
    $('#typ-button').blur().hide()
    $('#select-button').show().height(typH).focus()
    pos = $('#select-button').position()
    hgt = $('#select-button').height() + 6
    $('#select-menu').css('left', pos.left+5).css('top', pos.top+hgt).show()
    $('body').bind         'mousedown', (ev) => @checkForBlurSelectMenu(ev)
    $('.dateSel').bind     'mousedown', (ev) => @checkForBlurSelectMenu(ev)
    $('#select-menu').bind 'mousedown', (ev) => @clickOnSelectMenu(ev)
    $('#checkAll').bind    'click',     (ev) => @checkAll(ev)
    $('#clearAll').bind    'click',     (ev) => @clearAll(ev)

  clickOnSelectMenu: (ev) -> false

  checkForBlurSelectMenu: (ev) ->
    tgt = ev.target
    tgtId = $(tgt).attr('id')
    if tgtId != "select-menu"
      @blurSelectMenu()
      $('body, input, #select-menu').unbind('mouseup')
      $('.dateSel').unbind('mousedown')
      true
