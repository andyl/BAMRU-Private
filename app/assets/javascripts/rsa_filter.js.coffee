# for the RSA filter...
$(document).ready ->
  $('#rsa_check').prop("checked", true) if readCookie("rsa_show") == "true"
  $('#rsa_check').click ->
    if $('#rsa_check').is(':checked')
      createCookie("rsa_show", "true")
    else
      createCookie("rsa_show", "false")
    refresh_url = window.location.href.split('?', 1) + "?refresh=true"
    window.location.assign(refresh_url)