class BB.Collections.Participants extends Backbone.Collection

  model: BB.Models.Participant

  comparator: (par1, par2) ->
    typScore = (arr) -> arr[0]
    lastName = (arr) -> arr[1]
    sortKey1 = par1.sortKey()
    sortKey2 = par2.sortKey()
    if typScore(sortKey1) == typScore(sortKey2)
      return 0  if lastName(sortKey1) == lastName(sortKey2)
      return 1  if lastName(sortKey1) > lastName(sortKey2)
      return -1
    if typScore(sortKey1) > typScore(sortKey2) then 1 else -1

  findMatches: (string) ->
    @clearMatches()
    @each (participant) ->
      member = BB.members.get(participant.get('member_id'))
      fullName = member.fullName().toLowerCase()
      matchString = string.toLowerCase()
      if fullName.match(matchString)
        participant.set(matchMember: true)

  clearMatches: ->
    @each (participant) ->
      participant.unset('matchMember')

