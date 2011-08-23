class FileCacheSweeper < ActionController::Caching::Sweeper

  observe DataFile

  def expire_cached_content(entry)
    expire_fragment('files_table')
  end

  alias_method :after_save,    :expire_cached_content
  alias_method :after_destroy, :expire_cached_content

end
