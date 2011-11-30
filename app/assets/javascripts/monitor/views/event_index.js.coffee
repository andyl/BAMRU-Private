window.event_index_template = '''
<div class="xintro"><%= time %></div>
<div class="xcontent">
   <span class="xmem"><%= member %></span>
   <span class="xtxt"><%= event %><%= this.text_helper() %></span>
</div>
'''

class @Monitor_EventIndexView extends Monitor_CommonView
  tagName:    "div"
  className:  "xrow"
  text_helper: ->
    return "" unless @model.hasText()
    " - #{@model.get('text')}"
  initialize: ->
    @template = _.template(event_index_template)
  render: =>
    $(@el).html(@template(@model.toJSON()))
    @
