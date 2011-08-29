class MemberCacheSweeper < ActionController::Caching::Sweeper

  observe Member

  def expire_cached_content(entry)
    expire_fragment(/^member_index_table.*$/)
    expire_fragment('unit_photos_table')
    expire_fragment('unit_certs_table')
  end

  alias_method :after_save,    :expire_cached_content
  alias_method :after_destroy, :expire_cached_content

end