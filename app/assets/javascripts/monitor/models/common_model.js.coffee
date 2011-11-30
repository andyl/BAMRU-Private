class @Monitor_CommonModel extends Backbone.Model
  hasAttr: (attr) ->
    val = @get(attr)
    if val != undefined && val.length > 0 then true else false
    val != undefined && val.length != 0
