require 'launchy'

def login(member)
  visit login_path
  fill_in "user_name", :with => member.user_name
  fill_in "password",  :with => 'welcome'
  click_button 'Log in'
end