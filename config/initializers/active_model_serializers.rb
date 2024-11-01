class BaseAdapter < ActiveModelSerializers::Adapter::Attributes
  def serializable_hash(_options)
    if serializer.respond_to?(:each)
      serializer.map do |s|
        serializable_hash_for_single_resource(s)
      end
    else
      serializable_hash_for_single_resource(serializer)
    end
  end

  def serializable_hash_for_single_resource(serializer)
    {
      id:         serializer.object.id,
      class:      serializer.object.class,
      created_at: serializer.object.created_at,
      updated_at: serializer.object.updated_at,
      attributes: serializer.as_json
      # serializer.serializable_hash(instance_options, options, self)
    }
  end
end

# ActiveModelSerializers::Adapter::JsonApi
ActiveModelSerializers.config.adapter               = BaseAdapter
ActiveModelSerializers.config.default_includes      = '**'
ActiveModelSerializers.config.jsonapi_resource_type = :singular
# ActiveModelSerializers.config.jsonapi_include_toplevel_object  = true
# ActiveModelSerializers.config.key_transform                   = :underscore
# ActiveModelSerializers.config.jsonapi_include_toplevel_object = true
