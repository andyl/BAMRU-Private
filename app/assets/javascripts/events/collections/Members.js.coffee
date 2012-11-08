class BB.Collections.Members extends Backbone.Collection

  model: BB.Models.Member

  url: '/eapi/members'

  autoCompleteRoster: ->
    memberObj = (member) -> {label: "#{member.fullName()}", memberId: member.id}
    sortedRoster = @sortBy (member) -> "#{member.reverseName()}"
    _.map sortedRoster, (member) -> memberObj(member)

