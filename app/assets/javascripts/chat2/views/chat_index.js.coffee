window.chat_index_template = '''
<span class="created_at"><%= short_name %> | <%= created_at %></span>
<%= text %>
'''

class @C2_ChatIndexView extends Backbone.View
  tagName:    "li"
  initialize: ->
    @template = _.template(chat_index_template)
  render: =>
    $(@el).html(@template(@model.toJSON()))
    @
