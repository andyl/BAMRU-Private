class PhotoCacheSweeper < ActionController::Caching::Sweeper

  observe Photo

  def expire_cached_content(entry)
    expire_fragment(:fragment => 'unit_photos_table')
  end

  alias_method :after_save,    :expire_cached_content
  alias_method :after_destroy, :expire_cached_content

end