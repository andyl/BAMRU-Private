class BB.Views.UtilFooter extends Backbone.Marionette.ItemView

  template: 'events/templates/UtilFooter'

  el: "#x_footer"

  initialize: (options) ->
    @$el.addClass("bb-UtilFooter")
    @bindTo(BB.vent, 'hotkey:Change', @updateFooter, this)

  events:
    'click #shortCutLink' : 'hotKeyHelp'

  onRender: ->
    $('#x_footer').css('font-size',     '8pt')
    $('#x_footer').css('padding',       '0')
    $('#x_footer').css('padding-left',  '4px')
    $('#x_footer').css('padding-right', '4px')


  hotKeyHelp: -> BB.hotKeyHelp.toggle()

  updateFooter: ->
    string = _.map(BB.hotKeys.activeKeySets(), (set) -> set.help).filter((el) -> el != "TBD").join(', ')
    $('#hotKeyFooter').html(string)
