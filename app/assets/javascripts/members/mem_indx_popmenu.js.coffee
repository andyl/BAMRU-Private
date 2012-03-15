#= require members/mem_indx_checkbox

###
This file has one jQuery functions:
- update the number of characters left in the text box
###

#pager_icon:hover, #email_icon:hover {
#  cursor: pointer;
#  background: blue;
#}


$(document).ready ->
  pager_menu = new PopupMenu()
  pager_menu.add "Select All SMS", (target) -> selectSMS()
  pager_menu.add "Clear All SMS", (target) -> clearSMS()
  pager_menu.bind "pager_icon"
  
  email_menu = new PopupMenu()
  email_menu.add "Select All eMail", (target) -> selectMail()
  email_menu.add "Clear All eMail", (target) -> clearMail()
  email_menu.bind "email_icon"
