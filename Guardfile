# A sample Guardfile
# More info at https://github.com/guard/guard#readme
#

guard 'coffeescript', :output => 'public/javascripts/compiled' do
  watch('^app/coffeescripts/(.*)\.coffee')
end

guard 'coffeescript', :output => 'spec/javascripts' do
  watch('^spec/coffeescripts/(.*)\.coffee')
end

guard 'livereload' do
  watch('^spec/javascripts/.+\.js$')
  watch('^public/javascripts/compiled/.+\.js$')
end
