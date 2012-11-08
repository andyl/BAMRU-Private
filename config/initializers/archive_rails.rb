module Archive
  module Rails
    
    module ArchiveHelper
      
      def archive_document(opts={})
        base_dir = opts[:base_dir] || "zip_dir"
        zip_dir = "/tmp/#{base_dir}"

        system "rm -rf #{zip_dir}; mkdir -p #{zip_dir}"

        yield zip_dir if block_given?
        
        system "cd /tmp ; zip -q -r #{base_dir}.zip -xi #{base_dir}"
        File.read("#{zip_dir}.zip")
      end
      
    end
    
    class TemplateHandler

      def self.call(template)
        "#{template.source.strip}"
      end
      
    end
    
  end
end

# commented this for Rails 3.2.8
#Mime::Type.register_alias "application/zip", :zip
ActionView::Template.register_template_handler(:archive, Archive::Rails::TemplateHandler)
ActionView::Base.send(:include, Archive::Rails::ArchiveHelper)
