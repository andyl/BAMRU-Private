class BB.Views.SidebarRow extends Backbone.Marionette.ItemView

  template: 'events/templates/SidebarRow'

  templateHelpers: BB.Helpers.SidebarRowHelpers

  tagName: 'tr'

  events:
    "click": "clickRow"

  initialize: ->
    @$el.attr('id', "model_#{@model.get('id')}")
    @bindTo(@model, 'change', @render, this)

  clickRow: (event) ->
    event.preventDefault()
    BB.Routers.app.navigate("/events/#{@model.get('id')}", {trigger: true})

  onRender: ->
    removeHighLight = => @model.unset('pubSub')
    growl = =>
      userId   = @model.get('pubSub').userid
      user     = BB.members.get(userId)
      userName = user.shortName()
      action   = @model.get('pubSub').action
      showMsg  = (msg) -> toastr.info msg
      msg = switch action
        when "update"  then  showMsg "Event updated by #{userName}"
        when "add"     then  showMsg "New event added by #{userName}"
    if @model.get('pubSub')
      growl()
      setTimeout(removeHighLight, 3000)
