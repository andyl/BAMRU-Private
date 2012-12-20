class BB.Models.EventLink extends Backbone.Model

  site: ->
    url = @get('site_url')
    url?.split('/')[2]
