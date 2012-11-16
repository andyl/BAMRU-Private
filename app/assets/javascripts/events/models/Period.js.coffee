class BB.Models.Period extends Backbone.Model

  initialize: ->
    @participants     = new BB.Collections.Participants()
    @participants.url = "/eapi/periods/#{@id}/participants"
