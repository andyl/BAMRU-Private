class CertCacheSweeper < ActionController::Caching::Sweeper

  observe Cert

  def expire_cached_content(entry)
    expire_fragment('unit_certs_table')
  end

  alias_method :after_save,    :expire_cached_content
  alias_method :after_destroy, :expire_cached_content

end