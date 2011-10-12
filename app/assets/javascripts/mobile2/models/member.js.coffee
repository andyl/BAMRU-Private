
class @Member extends  Backbone.Model
  hasAttr: (attr) ->
    val = @get(attr)
    if val != undefined && val.length > 0 then true else false
  hasPhone: -> @hasAttr('phones_attributes')
  hasEmail: -> @hasAttr('emails_attributes')
  hasPhoto: -> @hasAttr('photos_attributes')
  hasEmergencyContact: -> @hasAttr('emergency_contacts_attributes')
  hasOtherInfo:        -> @hasAttr('other_infos_attributes')
  hasHam: -> @hasAttr('ham')
  hasV9: ->  @hasAttr('v9')