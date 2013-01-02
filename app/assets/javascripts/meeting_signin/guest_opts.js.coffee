class BB.GuestOpts
  constructor: ->
    attr = $("meta[name=\"csrf-token\"]").attr("content")
    console.log "INIT", attr
    @setToken(attr)
  baseOpts:
    "authenticity_token" : ""
    "member" :
      "full_name": ""
      "typ"      : "G"
      "phones_attributes" :
        "0" :
          "number" : ""
          "typ"    : "mobile"
      "emails_attributes" :
        "0" :
          "address" : ""
          "typ"     : "personal"
      "addresses_attributes" :
        "0" :
          "zip" : ""
          "typ" : "home"
          "is_guest" : "true"
  setToken: (token)   -> @baseOpts.authenticity_token = token
  setName:  (name)    -> @baseOpts.member.  full_name = name
  setPhone: (phone)   -> @baseOpts.member.  phones_attributes["0"].number = phone
  setEmail: (address) -> @baseOpts.member.  emails_attributes["0"].address = address
  setZip:   (zip)     -> @baseOpts.member.  addresses_attributes["0"].zip = zip
  createGuest: ->
    $.ajax
      type:    'POST'
      url:     '/eapi/members'
      data:    @baseOpts
      success: -> alert "IT WORKED"
      beforeSend: (xhr) ->
        token = $("meta[name=\"csrf-token\"]").attr("content")
        xhr.setRequestHeader "X-CSRF-Token", token  if token
