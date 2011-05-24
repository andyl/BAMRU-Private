# A sample Guardfile
# More info at https://github.com/guard/guard#readme
#

# CoffeeScript Functions
guard 'coffeescript', :output => 'public/javascripts/compiled' do
  watch(/^app\/assets\/javascripts\/(.*)\.coffee/)
end

# CoffeeScript Specs
guard 'coffeescript', :output => 'spec/javascripts/compiled' do
  watch(/^spec\/javascripts\/(.*)\.coffee/)
end

guard 'livereload', :apply_js_live => false do
  watch(/^spec\/javascripts\/(.+)\.js$/)
  watch(/^spec\/javascripts\/compiled\/(.+)\.js$/)
end
