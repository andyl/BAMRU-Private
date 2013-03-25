PDFKit.configure do |config|
  config.wkhtmltopdf = Rails.root.join('script', 'wkhtmltopdf').to_s
  # config.default_options = {
  #   :page_size => 'Legal',
  #   :print_media_type => true
  # }
  # config.root_url = "http://localhost" # Use only if your external hostname is unavailable on the server.
end