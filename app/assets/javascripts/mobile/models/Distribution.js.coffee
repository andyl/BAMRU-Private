#= require mobile/models/BaseModel

class BB.Models.Distribution extends BB.Models.BaseModel

  unitRoster: ->
    return @get('unitRoster') if @has('unitRoster')
    return members unless members == undefined
    null

  member: ->
    return null if @unitRoster() == null
    @unitRoster().get(@get('member_id'))