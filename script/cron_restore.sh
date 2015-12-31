echo ------- start restore -------
date
echo -----------------------------
killall ruby
bundle exec rake ops:restore:all db:drop db:create db:load
echo ------- finish restore ------
date
echo -----------------------------
