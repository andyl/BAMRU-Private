class BB.Views.AppBase extends Backbone.Marionette.Layout

  applyScaffold: ->
    @setColumnHeight()
    $(window).resize => @setColumnHeight()

  setColumnHeight: ->
    console.log "setting column height"
#    window.tgtHeight = window.innerHeight - 184 - $('#debug_footer').height()
#    $('#x_single_col').css('height', "#{tgtHeight}px")
