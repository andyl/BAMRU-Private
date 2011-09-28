# Support Code for TableSorter

window.RoleScore = class RoleScore
  constructor: (@input = "") ->
  to_lower:    -> @input.toLowerCase()
  input_array: -> @to_lower().split(' ')
  get_t:       -> "t"
  score_one: (role = @to_lower()) ->
    switch role
      when "a"  then -5
      when "s"  then -10
      when "r"  then -25
      when "t"  then -50
      when "fm" then -100
      when "tm" then -250
      when "ol" then -500
      when "bd" then -1000
      when "do" then -5000
      else 0
  score_array: ->
    @score_one(role) for role in @input_array()
  score: ->
    sum = 0
    (sum += val) for val in @score_array()
    sum

# expects an input like 'George Smith'
window.MemberName = class MemberName
  constructor: (@full_name = "") ->
  last_name: ->
    array = @full_name.replace(/\./,'').replace("\n", "").replace(/[ ]+/," ").replace(/[ ]+$/,"").split(' ')
    array[array.length - 1]

# expects an input like
# '<a href="/a/b/c">George Smith</a>'
# '<span>George Smith</span>'
# '<a href="/a/b/c"><span>George Smith</span></a>'
window.LinkName = class LinkName
  constructor: (@link = "") ->
  full_name: ->
    regex = /^.+\>([ A-z\.].+)\<\/a\>$/
    x = @link.replace(/\./g,"~")
    x.match(regex)[1].replace(/\~/g,".") 
  last_name: ->
    array = @full_name().split(' ')
    array[array.length - 1]
