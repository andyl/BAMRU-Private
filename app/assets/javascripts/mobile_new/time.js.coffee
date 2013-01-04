#(->
#  special = jQuery.event.special
#  uid1 = "D" + (+new Date())
#  uid2 = "D" + (+new Date() + 1)
#  special.scrollstart =
#    setup: ->
#      timer = undefined
#      handler = (evt) ->
#        _self = this
#        _args = arguments
#        if timer
#          clearTimeout timer
#        else
#          evt.type = "scrollstart"
#          jQuery.event.handle.apply _self, _args
#        timer = setTimeout(->
#          timer = null
#        , special.scrollstop.latency)
#
#      jQuery(this).bind("scroll", handler).data uid1, handler
#
#    teardown: ->
#      jQuery(this).unbind "scroll", jQuery(this).data(uid1)
#
#  special.scrollstop =
#    latency: 300
#    setup: ->
#      timer = undefined
#      handler = (evt) ->
#        _self = this
#        _args = arguments
#        clearTimeout timer  if timer
#        timer = setTimeout(->
#          timer = null
#          evt.type = "scrollstop"
#          jQuery.event.handle.apply _self, _args
#        , special.scrollstop.latency)
#
#      jQuery(this).bind("scroll", handler).data uid2, handler
#
#    teardown: ->
#      jQuery(this).unbind "scroll", jQuery(this).data(uid2)
#)()
