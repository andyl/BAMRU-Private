BB.Helpers.CnTabsMenuHelpers =

  linkUnlessCurrent: (page) ->
    capPage = _.string.capitalize(page)
    if page == @page
      capPage
    else
      "<a href='#' class='tmenuOpt' data-tgt='#{page}'>#{capPage}</a>"
