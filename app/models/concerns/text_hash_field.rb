module TextHashField
  extend ActiveSupport::Concern

  def merge_hash(field, hsh, deep = false)
    return if hsh.blank?

    old_value = send("#{field}") || {}
    new_value = if deep
                  old_value.deep_merge(hsh.deep_stringify_keys)
                else
                  old_value.merge(hsh.deep_stringify_keys)
                end
    send("#{field}=", new_value)
  end

  def deep_merge_hash

  end

  module ClassMethods
    def text_hash_field(field)
      serialize field, Hash
    end
  end
end
