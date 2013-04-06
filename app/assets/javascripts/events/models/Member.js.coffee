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
      when 'TM' then -500
      when 'FM' then -250
      when 'T'  then -100
      when 'R'  then -75
      when 'A'  then -50
      when 'S'  then -25
      when 'MA' then -20
      when 'G'  then -10
      when 'GA' then -5
      when 'MN' then -2
      when 'GN' then -1
      else 0

