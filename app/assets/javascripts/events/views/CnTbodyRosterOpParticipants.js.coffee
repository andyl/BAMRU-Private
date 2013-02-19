class BB.Views.CnTbodyRosterOpParticipants extends Backbone.Marionette.CompositeView

  # ----- configuration -----

  template: 'events/templates/CnTbodyRosterOpParticipants'
  itemView: BB.Views.CnTbodyRosterOpParticipant
  itemViewContainer: "tbody"
  templateHelpers: ->
    base = { participants: @collection }
    _.extend(base, BB.Helpers.CnTbodyRosterOpParticipantsHelpers)

  # ----- initialization -----

  initialize: (options) ->
    @model      = options.model                    # Period
    @collection = options.collection               # Participants
    @$el        = $("#zparticipants#{@model.id}")
    @bindTo(@collection, 'change', @render, this)
    @bindTo(@collection, 'remove', @render, this)
    @bindTo(@collection, 'reset',  @render, this)
    @bindTo(BB.vent,     'OLParticipantChange',  @collectionSort, this)

  onRender: ->
    @$el.find('.tablesorter th').css('font-size', '8pt')

  collectionSort: ->
    console.log "COLSORT"
    @collection.sort()
    @render()


