class BB.Models.Participant extends Backbone.Model

  sortKey: ->
    memberId = @get('member_id')
    member   = BB.members.get(memberId)
    olScore  = if @get('ol') then -500 else 0
    [olScore + member.typScore(), member.get('last_name')]
