class BB.Views.CnTabsMenu extends Backbone.Marionette.ItemView

  # ----- configuration -----

  template: 'events/templates/CnTabsMenu'
  templateHelpers: BB.Helpers.CnTabsMenuHelpers
  pages: ["overview", "roster", "journal", "forum", "media", "chronicle"]

  # ----- initialization -----

  initialize: (page) ->
    @curPage  = page
    @numPages = @pages.length
    @model = new Backbone.Model()
    @model.set({page: page})
    @bindTo(BB.vent, 'click:tMenu:Next', @nextMenu, this)
    @bindTo(BB.vent, 'click:tMenu:Prev', @prevMenu, this)

  events:
    "click .tmenuOpt" : "menuClick"

  onShow: ->
    BB.hotKeys.enable("CnTabsMenu")

  onClose: ->
    BB.hotKeys.disable("CnTabsMenu")

  # ----- methods -----

  menuClick: (event) ->
    event.preventDefault()
    pageName = $(event.target).data('tgt')
    BB.vent.trigger("click:tMenu", pageName)


  # ----- next/previous -----

  nextMenu: ->
    curIdx = _.indexOf(@pages, @curPage)
    newIdx = if curIdx == @numPages-1 then 0 else curIdx + 1
    newPage = @pages[newIdx]
    BB.vent.trigger('click:tMenu', newPage)

  prevMenu: ->
    curIdx = _.indexOf(@pages, @curPage)
    newIdx = if curIdx == 0 then @numPages-1 else curIdx-1
    newPage = @pages[newIdx]
    BB.vent.trigger('click:tMenu', newPage)





