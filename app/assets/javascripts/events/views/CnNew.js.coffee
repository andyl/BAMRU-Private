class BB.Views.CnNew extends Backbone.Marionette.Layout

  template: 'events/templates/CnNew'

  regions:
    formEl: '#newEventForm'

  initialize: (options) ->
    opts = options?.attributes || {}
    delete opts.id
    @model = new BB.Models.Event(opts)

  onShow: ->
    BB.vent.trigger("show:CnNew")
    $('#new-event-button').hide()
    @formEl.show(new BB.Views.CnNewForm({model: @model}))

  onClose: ->
    $('#new-event-button').show()

