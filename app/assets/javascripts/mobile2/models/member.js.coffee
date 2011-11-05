#= require ./common_model

class @M2_Member extends M2_CommonModel
  hasPhone: -> @hasAttr('phones_attributes')
  hasEmail: -> @hasAttr('emails_attributes')
  hasPhoto: -> @hasAttr('photos_attributes')
  hasEmergencyContact: -> @hasAttr('emergency_contacts_attributes')
  hasOtherInfo:        -> @hasAttr('other_infos_attributes')
  hasHam: -> @hasAttr('ham')
  hasV9: ->  @hasAttr('v9')