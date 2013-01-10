#= require mobile/models/common_model

class @M3_Distribution extends M3_CommonModel
  unitRoster: ->
    return @get('unitRoster') if @has('unitRoster')
    return members unless members == undefined
    null
  member: ->
    return null if @unitRoster() == null
    @unitRoster().get(@get('member_id'))