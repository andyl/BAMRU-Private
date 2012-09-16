window.BbmEvent = Backbone.Model.extend

  viewHelpers:
    hDate: ->
      @start
    hTyp: ->
      output = _.string.capitalize(@typ)
      if output == "Special" then "Special Event" else output
    hPublished: ->
      return "" if @published == "true"
      "(not published)"


