class BB.Views.CnIndx extends Backbone.Marionette.ItemView

  template: 'events/templates/CnIndx'

  onShow: ->
    BB.hotKeys.add("CnSharedKeys", new BB.HotKeys.CnSharedKeys())
    BB.vent.trigger("show:CnIndx")

  onClose: ->
    BB.hotKeys.remove("CnSharedKeys")
