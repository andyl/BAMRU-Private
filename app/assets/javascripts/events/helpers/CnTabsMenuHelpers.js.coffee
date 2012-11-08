BB.Helpers.CnTabsMenuHelpers =

  linkUnlessCurrent: (page) ->
    capPage = _.string.capitalize(page)
    if page == @page
      "<b>#{capPage}</b>"
    else
      "<a href='#' class='tmenuOpt' data-tgt='#{page}'>#{capPage}</a>"
