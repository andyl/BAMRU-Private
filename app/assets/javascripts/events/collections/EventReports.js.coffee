class BB.Collections.EventReports extends Backbone.Collection

  model: BB.Models.EventReport

  comparator: (par1, par2) ->
    up1 = par1.get('title')
    up2 = par2.get('title')
    return 0  if up1 == up2
    return 1  if up1 > up2
    return -1