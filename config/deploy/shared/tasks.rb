share_local = File.expand_path(File.dirname(__FILE__))
Dir.glob("#{share_local}/base/*.rb").each    {|f| require f}
Dir.glob("#{share_local}/recipes/*.rb").each {|f| require f}