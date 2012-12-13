# ----- KeySet Classes -----

class BB.HotKeys.KeySet
  hotKeys    : {}
  active     : false
  constructor: (config) ->
    @mode        = config.mode   || "TBD"
    @help        = config.help   || "TBD"
    @keyMap      = config.keyMap || {}
    @displaySort = config.displaySort || 0
  # ----- used to generate help text -----
  mapCount: -> Object.keys(@keyMap).length + 1
  bindKeys:   -> @applyToAllKeys(@bindKey)
  unbindKeys: -> @applyToAllKeys(@unbindKey)
  # ----- private methods -----
  alreadyBound: (key) ->
    return false unless eventList = $(document).data('events').keydown
    _.any(eventList, (ob) -> ob.data == key)
  bindKey: (key, keySet) =>
    # note: this guard implies that you can't re-assign a key
    # TODO: change this, to allow a key to be re-assigned
    # simplest: just delete the bound key
    return if @alreadyBound(key)
    bindRef = "keydown.#{key}"
    doBind  = (el) => $(el).bind(bindRef, key, => @executeKey(key, keySet))
    doBind(document)
    unless keySet.disableOnForms
      doBind('input')
      doBind('select')
      doBind('textarea')
  unbindKey: (key) =>
    bindRef = "keydown.#{key}"
    $(document).unbind(bindRef)
    $('input').unbind(bindRef)
    $('textarea').unbind(bindRef)
  executeKey: (key, keySet) =>
    keySet.func()
  applyToAllKeys: (func) ->
    _.keys(@keyMap).map (label) =>
      _.map @keyMap[label].keys.split(', '), (key) =>
        func(key, @keyMap[label])

class BB.HotKeys.KeySets
  debug: false
  keySets: {}
  activeKeySets: -> _.select @keySets, (keySet) -> keySet.active
  add: (keySetName, keySetObj) ->
    @keySets[keySetName] = keySetObj
  remove: (keySetName) ->
    delete @keySets[keySetName]
  enable: (keySetName) ->
    console.log "HK enable", keySetName if @debug
    @keySets[keySetName].active = true
    @keySets[keySetName].bindKeys()
    BB.vent.trigger("hotkey:Change")
  disable: (keySetName) ->
    console.log "HK disable", keySetName if @debug
    @keySets[keySetName].active = false
    @keySets[keySetName].unbindKeys()
    BB.vent.trigger("hotkey:Change")
  rebindAllKeySets: ->
    $(document).unbind('keydown')
    $('input').unbind('keydown')
    $('textarea').unbind('keydown')
    _.each @activeKeySets(), (keySet) -> keySet.bindKeys()

class BB.HotKeys.HotKeyHelp

  renderKey: (key, desc) ->
    "<tr><td align='right' width=60>#{key}</td><td>: #{desc}</td></tr>"

  renderKeyMap: (keyMap) ->
    _.map(keyMap, (object, key) => @renderKey(object.keys, key)).join('')

  renderKeySet: (keySet) ->
    """
      <div class='keySet'>
        <div class='keyMode'><b>#{keySet.mode}</b></div>
        <table>
          #{@renderKeyMap(keySet.keyMap)}
        </table>
      </div>
    """

  assembleDisplay: (leftCol, rightCol) ->
    leftTxt  = _.map(leftCol,  (value, key) => @renderKeySet(value)).join('')
    rightTxt = _.map(rightCol, (value, key) => @renderKeySet(value)).join('')
    """
      <table width=100%>
         <tr><td>#{leftTxt}</td><td>#{rightTxt}</td></tr>
      </table>
    """

  displaySort: (col) ->
    sortScore = (ele)   -> ele.displaySort || 0
    _.sortBy col, (ele) -> sortScore(ele)

  display: ->
    targetKeySets = _.select BB.hotKeys.keySets, (ele) -> ele.mode != "TBD"
    sortedKeySets = _.sortBy targetKeySets, (value, key) -> -1 * value.mapCount()
    window.leftCol  = []
    window.rightCol = []
    sumLen = (arr) ->
      _.reduce(
        arr,
        (sum, ele) -> sum + ele.mapCount(),
        0)
    assignCol = (val) =>
      leftLen  = sumLen(window.leftCol)
      rightLen = sumLen(window.rightCol)
      if leftLen <= rightLen
        window.leftCol = window.leftCol.concat([val])
      else
        window.rightCol = window.rightCol.concat([val])
    _.each(sortedKeySets, (value) => assignCol(value))
    window.leftCol = @displaySort(window.leftCol)
    window.rightCol = @displaySort(window.rightCol)
    helpText = @assembleDisplay(window.leftCol, window.rightCol)
    $('#hotKeyHelp').html(helpText)
    opts =
      minWidth:  550
      modal:     true
      title:     "Keyboard Shortcuts for Events"
      resizable: false
    $('#hotKeyHelp').dialog(opts)
    $('#hotKeyHelp td, #hotKeyHelp b').css('font-size' : '10pt')

  hide: ->
    $('#hotKeyHelp').dialog("destroy")

  toggle: ->
    if $('.ui-dialog-content').length == 0
      @display()
      return
    if $('#hotKeyHelp').dialog("isOpen") == true then @hide() else @display()

# ----- Key Definitions -----

BB.hotKeys = new BB.HotKeys.KeySets()
BB.hotKeyHelp = new BB.HotKeys.HotKeyHelp()
hotKeys = BB.hotKeys

hotKeys.keySets["SidebarControl"] = new BB.HotKeys.KeySet
  mode: "Filtering and Searching"
  keyMap:
    'create new event':
      keys: 'n'
      func: -> BB.vent.trigger "cmd:SidebarControlNew"
      disableOnForms: true
    'reset filter/search/sort':
      keys: 'r'
      func: -> BB.vent.trigger "cmd:SidebarControlReset"
      disableOnForms: true
    "show only Meetings":
      keys: 'shift+m'
      func: -> BB.vent.trigger("cmd:ExclusiveCheckbox", "meeting")
      disableOnForms: true
    "show only Trainings":
      keys: 'shift+t'
      func: -> BB.vent.trigger("cmd:ExclusiveCheckbox", "training")
      disableOnForms: true
    "show only Operations":
      keys: 'shift+o'
      func: -> BB.vent.trigger("cmd:ExclusiveCheckbox", "operation")
      disableOnForms: true
    "show only Community":
      keys: 'shift+c'
      func: -> BB.vent.trigger("cmd:ExclusiveCheckbox", "community")
      disableOnForms: true
#    "show only Social":
#      keys: 'shift+s'
#      func: -> BB.vent.trigger("cmd:ExclusiveCheckbox", "social")
#      disableOnForms: true
    "toggle Meetings":
      keys: 'm'
      func: -> BB.vent.trigger("cmd:ToggleCheckbox", "meeting")
      disableOnForms: true
    "toggle Trainings":
      keys: 't'
      func: -> BB.vent.trigger("cmd:ToggleCheckbox", "training")
      disableOnForms: true
    "toggle Operations":
      keys: 'o'
      func: -> BB.vent.trigger("cmd:ToggleCheckbox", "operation")
      disableOnForms: true
    "toggle Community":
      keys: 'c'
      func: -> BB.vent.trigger("cmd:ToggleCheckbox", "community")
      disableOnForms: true
#    "toggle Social":
#      keys: 's'
#      func: -> BB.vent.trigger("cmd:ToggleCheckbox", "social")
#      disableOnForms: true
    'show all event types':
      keys: 'shift+a'
      func: -> BB.vent.trigger "cmd:SidebarControlCheckAll"
      disableOnForms: true
    'toggle all event types':
      keys: 'a'
      func: -> BB.vent.trigger "cmd:SidebarControlToggleAll"
      disableOnForms: true
    'toggle search':
      keys: 'alt+/'
      func: -> BB.vent.trigger "cmd:SidebarFilterFocus"

hotKeys.keySets["CnTbodyOverviewShow"] = new BB.HotKeys.KeySet
  mode: "When Viewing an Event"
  help: "<b>e</b> edit, <b>p</b> reproduce, <b>d</b> delete"
  keyMap:
    'edit event':
      keys: 'e'
      func: -> BB.vent.trigger "click:CnTabsOverviewEdit"
      disableOnForms: true
    'reproduce event':
      keys: 'p'
      func: -> BB.vent.trigger "click:CnTabsOverviewCloneHotKey"
      disableOnForms: true
    'delete event':
      keys: 'd'
      func: -> BB.vent.trigger "click:CnTabsOverviewDeleteHotKey"
      disableOnForms: true

hotKeys.keySets["CnSharedForm"] = new BB.HotKeys.KeySet
  mode: "When Editing an Event"
  help: "<b>&</b> save, <b>#</b> cancel"
  keyMap:
    'save':
      keys: "&"
      func: -> BB.vent.trigger "cmd:EditEventSave"
    'cancel':
      keys: '#'
      func: -> BB.vent.trigger "cmd:EditEventCancel"

hotKeys.keySets["CnTbodyRosterMt"] = new BB.HotKeys.KeySet
  help: "<b>alt+p</b> toggle add participant"
  keyMap:
    'toggle add particpant':
      keys: "alt+p"
      func: -> BB.vent.trigger "cmd:ToggleAddParticipant"

hotKeys.keySets["CnTbodyRosterOp"] = new BB.HotKeys.KeySet
  mode: "When Viewing a Roster"
  help: "<b>alt+p</b> toggle add participant, <b>alt+j</b> next period, <b>alt+k</b> prev period"
  keyMap:
    'toggle add particpant':
      keys: "alt+p"
      func: -> BB.vent.trigger "cmd:ToggleAddParticipant"
    'next period':
      keys: "alt+j"
      func: -> BB.vent.trigger "cmd:NextPeriod"
    'prev period':
      keys: "alt+k"
      func: -> BB.vent.trigger "cmd:PrevPeriod"
    'maximize/minimize period':
      keys: "alt+m"
      func: -> BB.vent.trigger "cmd:ToggleMinMax"
    'minimize other periods':
      keys: "alt+o"
      func: -> BB.vent.trigger "cmd:MinOtherPeriods"
    'change time fields':
      keys: "alt+t"
      func: -> BB.vent.trigger "cmd:TogglePeriodTimes"
    'create new period':
      keys: "alt+n"
      func: -> BB.vent.trigger "cmd:AddNewPeriod"
    'delete period':
      keys: "alt+d"
      func: -> BB.vent.trigger "cmd:DeletePeriod"


hotKeys.keySets["SidebarList"] = new BB.HotKeys.KeySet
  mode: "Event List (Sidebar)"
  help: "<b>j</b> next event, <b>k</b> prev event"
  keyMap:
    'next event':
      keys: 'j'
      func: -> BB.vent.trigger "key:nextRow"
      disableOnForms: true
    'prev event':
      keys: 'k'
      func: -> BB.vent.trigger "key:prevRow"
      disableOnForms: true
    'move to top event':
      keys: 'g'
      func: -> BB.vent.trigger "key:topRow"
      disableOnForms: true
    'move to bottom event':
      keys: 'shift+g'
      func: -> BB.vent.trigger "key:bottomRow"
      disableOnForms: true

hotKeys.keySets["CnTabsMenu"] = new BB.HotKeys.KeySet
  mode: "Event Tabs (Overview, Roster, ...)"
  help: "<b>h</b> move left, <b>l</b> move right"
  keyMap:
    'move left':
      keys: "h"
      func: -> BB.vent.trigger "click:tMenu:Prev"
      disableOnForms: true
    'move right':
      keys: "l"
      func: -> BB.vent.trigger "click:tMenu:Next"
      disableOnForms: true

hotKeys.keySets["AppLayout"] = new BB.HotKeys.KeySet
  mode: "On Every Screen"
  displaySort: 100
  keyMap:
    'go to home screen':
      keys: '^'
      func: => BB.vent.trigger "key:Home"
    'open/close sidebar panel':
      keys: '!'
      func: => BB.vent.trigger "key:ToggleSidebar"
    'toggle shortcut help':
      keys: '*'
      func: -> BB.hotKeyHelp.toggle()
