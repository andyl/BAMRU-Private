# ----- KeySet Classes -----

class BB.HotKeys.KeySet
  hotKeys    : {}
  bindKeys: ->
    _.keys(@hotKeys).map (label) =>
      _.map @hotKeys[label].keys.split(', '), (key) =>
        $(document).bind('keydown', key, @hotKeys[label].func)
        unless @hotKeys[label].disableOnForms
          $('input').bind('keydown', key, @hotKeys[label].func)
          $('textarea').bind('keydown', key, @hotKeys[label].func)

class BB.HotKeys.KeySets
  collection: {}
  add: (keySetName, keySetObj) ->
#    console.log "HK add", keySetName
    @collection[keySetName] = keySetObj
    keySetObj.bindKeys()
  remove: (keySetName) ->
#    console.log "HK remove", keySetName, @collection
    delete @collection[keySetName]
    @rebindKeys()
  rebindKeys: ->
    $(document).unbind('keydown')
    $('input').unbind('keydown')
    $('textarea').unbind('keydown')
    _.values(@collection).map (keySet) -> keySet.bindKeys()

# ----- KeySet Definitions -----

class BB.HotKeys.CnSharedKeys extends BB.HotKeys.KeySet
  mode: "Event Navigation"
  help: "j/k : next/prev, alt+/ : toggle search"
  hotKeys:
    'show next event':
      keys: 'j'
      func: -> BB.vent.trigger "key:nextRow"
      disableOnForms: true
    'show previous event':
      keys: 'k'
      func: -> BB.vent.trigger "key:prevRow"
      disableOnForms: true
    'search':
      keys: 'alt+/'
      func: -> BB.vent.trigger "cmd:SidebarFilterFocus"
    "toggle Meeting display":
      keys: 'shift+m'
      func: -> BB.vent.trigger("cmd:ToggleCheckbox", "meeting")
      disableOnForms: true
    "toggle Training display":
      keys: 'shift+t'
      func: -> BB.vent.trigger("cmd:ToggleCheckbox", "training")
      disableOnForms: true
    "toggle Operations display":
      keys: 'shift+o'
      func: -> BB.vent.trigger("cmd:ToggleCheckbox", "operation")
      disableOnForms: true
    "toggle Community display":
      keys: 'shift+c'
      func: -> BB.vent.trigger("cmd:ToggleCheckbox", "community")
      disableOnForms: true
    "toggle Social display":
      keys: 'shift+s'
      func: -> BB.vent.trigger("cmd:ToggleCheckbox", "social")
      disableOnForms: true
    "show only Meetings":
      keys: 'alt+shift+m'
      func: -> BB.vent.trigger("cmd:ExclusiveCheckbox", "meeting")
      disableOnForms: true
    "show only Trainings":
      keys: 'alt+shift+t'
      func: -> BB.vent.trigger("cmd:ExclusiveCheckbox", "training")
      disableOnForms: true
    "show only Operations":
      keys: 'alt+shift+o'
      func: -> BB.vent.trigger("cmd:ExclusiveCheckbox", "operation")
      disableOnForms: true
    "show only Community":
      keys: 'alt+shift+c'
      func: -> BB.vent.trigger("cmd:ExclusiveCheckbox", "community")
      disableOnForms: true
    "show only Social":
      keys: 'alt+shift+s'
      func: -> BB.vent.trigger("cmd:ExclusiveCheckbox", "social")
      disableOnForms: true

class BB.HotKeys.CnTbodyOverviewShowKeys extends BB.HotKeys.KeySet
  initialize: -> console.log "HK CnTabsOverviewShowKeys"
  mode: "Event Selected"
  help: "e - edit"
  hotKeys:
    'edit event':
      keys: 'e'
      func: -> BB.vent.trigger "click:CnTabsOverviewEdit"
      disableOnForms: true
    'clone event':
      keys: 'c'
      func: -> BB.vent.trigger "click:CnTabsOverviewCloneHotKey"
      disableOnForms: true
    'delete event':
      keys: 'd'
      func: -> BB.vent.trigger "click:CnTabsOverviewDeleteHotKey"
      disableOnForms: true

class BB.HotKeys.CnTbodyOverviewEditKeys extends BB.HotKeys.KeySet
  mode: "Event Edit"
  help: "alt+s, alt+w: save event, alt+c: cancel event"
  hotKeys:
    'save event':
      keys: "alt+s, alt+w"
      func: -> BB.vent.trigger "cmd:EditEventSave"
    'cancel event editing':
      keys: 'alt+c'
      func: -> BB.vent.trigger "cmd:EditEventCancel"

class BB.HotKeys.CnTabsMenuKeys extends BB.HotKeys.KeySet
  mode: "Event Tabs"
  hotKeys:
    'Previous Tab':
      keys: "alt+h"
      func: -> BB.vent.trigger "click:tMenu:Prev"
    'Next Tab':
      keys: "alt+l"
      func: -> BB.vent.trigger "click:tMenu:Next", "roster"

