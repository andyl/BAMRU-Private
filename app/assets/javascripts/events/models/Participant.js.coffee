class BB.Models.Participant extends Backbone.Model

  sortKey: ->
    member = BB.members.get(@get('member_id'))
    return 0 if member == undefined
    olScore = if @get('ol') then -500 else 0
    [olScore + member.typScore(), member.get('last_name')]
