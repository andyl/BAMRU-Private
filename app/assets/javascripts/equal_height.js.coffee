# sets the columns to equal height
equalHeight = (c1, c2) ->
  c1Height = $(c1).height()
  c2Height = $(c2).height()
  if(c1Height > c2Height)
    $(c2).height(c1Height)
  else
    $(c1).height(c2Height)

$(document).ready ->
  equalHeight("#x_right_col", "#x_left_col")