#= require mobile/models/BaseModel

class BB.Models.Member extends BB.Models.BaseModel
  hasPhone:     -> @hasAttr('phones_attributes')
  hasEmail:     -> @hasAttr('emails_attributes')
  hasPhoto:     -> @hasAttr('photo')
  hasContact:   -> @hasAttr('contacts_attributes')
  hasOtherInfo: -> @hasAttr('other_infos_attributes')
  hasHam:       -> @hasAttr('ham')
  hasV9:        -> @hasAttr('v9')
  shortName: ->
    initial = @get('first_name').substring(0,1)
    "#{initial}. #{@get('last_name')}"