require 'spreadsheet'

module Spreadsheet
  class Workbook
    def render
      self.write '/tmp/xx.xls'
      File.read '/tmp/xx.xls'
    end
  end
end

module Spreadsheet
  module Rails
    
    module SpreadsheetHelper
      
      def spreadsheet_document(opts={})
        download = opts.delete(:force_download)
        filename = opts.delete(:filename)
        xls = (opts.delete(:renderer) || Spreadsheet::Workbook).new(opts)
        
        yield xls if block_given?
        
        disposition(download, filename) if (download || filename)
        
        xls
      end
      
      def disposition(download, filename)
        download = true if (filename && download == nil)
        disposition = download ? "attachment;" : "inline;"
        disposition += " filename=#{filename}" if filename
        headers["Content-Disposition"]=disposition
      end
      
    end
    
    class TemplateHandler #< ActionView::Template::Handler
#      self.default_format = :xls
      
      def self.call(template)
        "#{template.source.strip}.render"        
      end
      
    end
    
  end
end

Mime::Type.register_alias "application/xls", :xls
ActionView::Template.register_template_handler(:spreadsheet, Spreadsheet::Rails::TemplateHandler)
ActionView::Base.send(:include, Spreadsheet::Rails::SpreadsheetHelper)
