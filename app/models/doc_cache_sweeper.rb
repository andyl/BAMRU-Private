class DocCacheSweeper < ActionController::Caching::Sweeper

  observe Doc

  def expire_cached_content(entry)
    expire_fragment(:fragment => 'docs_table')
  end

  alias_method :after_save,    :expire_cached_content
  alias_method :after_destroy, :expire_cached_content

end