module CacheHelper
  def cache_key
    ActiveSupport::Cache.expand_cache_key(declared_params.to_hash)
  end

  def etag_key
    SyncLog.last.try(:updated_at) || Time.current
  end

  def cache_day_count!(record)
    return if record.nil?

    Rails.cache.write(cache_day_key(record), get_cache_day_count!(record) + 1, expires_in: 2.day)
  end

  def get_cache_day_count!(record)
    return if record.nil?

    Rails.cache.read(cache_day_key(record)) || 0
  end

  def cache_day_key(record)
    "#{Date.today}/count/#{record.class.name}/#{record.id}"
  end
end
