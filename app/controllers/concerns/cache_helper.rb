module CacheHelper
  def cache_key
    ActiveSupport::Cache.expand_cache_key(declared_params.to_hash)
  end

  def etag_key
    SyncLog.last.try(:updated_at) || Time.current
  end
end
