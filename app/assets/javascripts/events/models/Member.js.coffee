class BB.Models.Member extends Backbone.Model

  # ----- configuration -----

  urlRoot: '/eapi/members'

  # ----- initialization -----

  # ----- methods -----

  isAdmin:     -> @get('admin')
  isDeveloper: -> @get('developer')
  fullName:    -> "#{@get('first_name')} #{@get('last_name')}"
  shortName:   -> "#{@get('first_name')[0]}. #{@get('last_name')}"
  reverseName: -> "#{@get('last_name')}. #{@get('first_name')}"
  typScore: ->
    switch @get('typ')
      when 'TM' then -100
      when 'FM' then -50
      when 'T'  then -25
      when 'A'  then -20
      when 'S'  then -10
      when 'G'  then -5
      when 'I'  then 0
      else 0

