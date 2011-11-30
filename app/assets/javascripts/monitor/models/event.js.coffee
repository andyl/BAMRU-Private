#= require monitor/models/common_model

class @Monitor_Event extends Monitor_CommonModel
  hasText: -> @hasAttr('text')