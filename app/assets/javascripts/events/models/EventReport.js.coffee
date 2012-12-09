class BB.Models.EventReport extends Backbone.Model

  setData: (field, value) ->
    dataObj = @get('data')
    dataObj[field] = value
    @set({data: dataObj})
