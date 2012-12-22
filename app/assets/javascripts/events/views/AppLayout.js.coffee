class BB.Views.AppLayout extends Backbone.Marionette.Layout

  # ----- configuration -----

  template: 'events/templates/AppLayout'
  el      : '#x_single_col'

  regions:
    control: '#sidebar-control'
    list   : '#sidebar-list'
    content: '#content'

  # ----- initialization -----

  onRender: ->
    @applyScaffold()
    @showSidebar()
    @bindTo(BB.vent,     'click:CnTabsOverviewClone',       @clone,         this)
    @bindTo(BB.vent,     'click:CnTabsOverviewCancelClone', @cancelClone,   this)
    @bindTo(BB.vent,     'key:Home',                        @goHome,        this)
    @bindTo(BB.vent,     'key:ToggleSidebar',               @toggleSidebar, this)
    @bindTo(BB.vent,     'key:OpenSidebar',                 @openSidebar, this)
    BB.Views.utilFooter.render().updateFooter()
    BB.hotKeys.enable("AppLayout")

  onClose: ->
    BB.hotKeys.disable("AppLayout")

  # ----- event handlers (clone) -----

  clone: (model) ->
    @lastModel = model
    @content.show(new BB.Views.CnNew({attributes: model.toJSON()}))
    BB.Routers.app.navigate("/events/new")

  cancelClone: ->
    if @lastModel?
      BB.Routers.app.navigate("/events/#{@lastModel.get('id')}", {trigger: true})
    else
      BB.Routers.app.navigate("/events", {trigger: true})
      
  # ----- event handlers (misc) -----
  
  toggleSidebar: ->
    @jsLayout.toggle('west')

  openSidebar: ->
    @jsLayout.open('west')

  goHome: ->
    @jsLayout.open('west')
    BB.vent.trigger "key:topRow"
    BB.Routers.app.navigate("/events", {trigger: true})

  # ----- sidebar -----

  showSidebar: ->
    @sidebarControl = new BB.Views.SidebarControl({model: BB.UI.filterState})
    @control.show(@sidebarControl)
    @sidebarList = new BB.Views.SidebarList({collection: BB.Collections.filteredEvents})
    @sidebarList.render()

  # ----- tabs -----

  showTabs: (opts) ->
    tabView  = new BB.Views.CnTabs(opts)
    @content.show(tabView)

  # ----- layout -----

  applyScaffold: ->
    layoutOptions =
      applyDefaultStyles: true
      west__resizable   : false
      west__size        : 320
      center__onresize  : => @setContentWidth()
    @setColumnHeight()
    $(window).resize => @setColumnHeight()
    @jsLayout = $('#x_single_col').layout(layoutOptions)
    @setContentWidth()

  setContentWidth: ->
    el = $('#content')
    if $(el).width() > 650
      $(el).width(876)
    else
      $(el).width(535)

  setColumnHeight: ->
    window.tgtHeight = window.innerHeight - 184 - $('#debug_footer').height()
    $('#x_single_col').css('height', "#{tgtHeight}px")
    $('#sidebar').height(tgtHeight - 18)
    $('#content').height(tgtHeight - 42)
    @updateSidebar()
    window.setTimeout(@updateSidebar, 250)

  updateSidebar: ->
    $('#sidebar').height(tgtHeight - 18)
    $('#content').height(tgtHeight - 18)


