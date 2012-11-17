class BB.Views.CnTbodyRosterOpParticipant extends Backbone.Marionette.ItemView

  # ----- configuration -----

  template: 'events/templates/CnTbodyRosterOpParticipant'

  templateHelpers: -> BB.Helpers.CnTbodyRosterOpParticipantHelpers

  tagName: "tr"

  # ----- initialization -----

  initialize: (options) ->
    @model      = options.model       # Participant
    @bindTo(@model, 'change:ol', @reRender, this)

  reRender: ->
    BB.vent.trigger("OLParticipantChange")
    @render()

  events:
    'click .deleteParticipant' : 'deleteParticipant'
    'click .unsetOL'           : 'unsetOL'
    'click .setOL'             : 'setOL'

  # ----- methods -----

  deleteParticipant: (ev) ->
    ev?.preventDefault()
    @model.destroy()

  unsetOL: (ev) ->
    ev?.preventDefault()
    @model.save({"ol" : false})

  setOL: (ev) ->
    ev?.preventDefault()
    @model.save({"ol" : true})

  onRender: ->
    @$el.find("td").css('font-size', '8pt')
    @$el.find("#enroute#{@model.id}, #return#{@model.id}").datetimepicker
      showMonthAfterYear: true
      changeMonth       : true,
      changeYear        : true,
      dateFormat        : "yy-mm-dd"
      onClose           : =>
        formEnRoute  = @$el.find("#enroute#{@model.id}").val()
        modelEnRoute = @model.get('en_route_at')
        formReturn   = @$el.find("#return#{@model.id}").val()
        modelReturn  = @model.get('return_home_at')
        return if modelEnRoute == formEnRoute && modelReturn == formReturn
        returnVal = if formEnRoute >= modelReturn then "" else modelReturn
        @model.save
          en_route_at    : formEnRoute
          return_home_at : returnVal
          updated_at     : moment().strftime("%y-%m-%d %H:%M")
    @$el.find("#checkedIn#{@model.id}, #checkedOut#{@model.id}").datetimepicker
      showMonthAfterYear: true
      changeMonth       : true,
      changeYear        : true,
      dateFormat        : "yy-mm-dd"
      onClose           : =>
        formCheckedIn   = @$el.find("#checkedIn#{@model.id}").val()
        modelCheckedIn  = @model.get('checked_in_at')
        formCheckedOut  = @$el.find("#checkedOut#{@model.id}").val()
        modelCheckedOut = @model.get('checked_out_at')
        return if modelCheckedIn == formCheckedIn && modelCheckedOut == formCheckedOut
        returnVal = if formCheckedIn >= modelCheckedOut then "" else modelCheckedOut
        @model.save
          checked_in_at  : formCheckedIn
          checked_out_at : returnVal
          updated_at     : moment().strftime("%y-%m-%d %H:%M")