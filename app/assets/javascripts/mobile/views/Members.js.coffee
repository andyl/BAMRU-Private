memberRowTemplate = '''
<a class="nav memNav" href="/mobile/members/<%= id %>"><%= first_name %> <%= last_name %> (<%= typ %>)</a>
'''

class BB.Views.MemberRow extends Backbone.Marionette.ItemView

  tagName: "span"

  initialize: ->
    @template = _.template(memberRowTemplate)

  render: =>
    @$el.html(@template(@model.toJSON()))
    @


class BB.Views.Members extends Backbone.Marionette.CollectionView

  # ----- configuration -----

  events:
    "click .memNav"  : "memNav"

  # ----- event handlers -----

  memNav: (ev) ->
    ev.preventDefault()
    href = $(ev.target).attr('href')
    BB.Routers.app.navigate(href, {trigger: true})

  render: =>
    @$el.html("")
    BB.Collections.members.each (member) =>
      view = new BB.Views.MemberRow({model: member})
      @$el.append(view.render().el)
    $('.clickHome').show()
    @

