class BB.Models.EventReport extends Backbone.Model

  setData: (field, value, opts = {}) ->
    dataObj = @get('data')
    dataObj[field] = value
    @set({data: dataObj}, opts)
