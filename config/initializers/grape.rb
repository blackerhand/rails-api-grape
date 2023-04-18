# frozen_string_literal: true

Grape.configure do |config|
  config.param_builder = Grape::Extensions::Hashie::Mash::ParamBuilder
end

module Grape
  # i18n rewrite
  module Exceptions
    class Base
      def translate_key(key)
        key.delete(']').split('[')[-2..-1].join('.')
      end

      protected

      def translate_attribute(key, **options)
        if key.include?('[')
          translate("activerecord.attributes.#{translate_key(key)}", default: key, **options)
        else
          translate("activerecord.models.#{key}", default: key, **options)
        end
      end

      def translate_attributes(keys, **options)
        keys.map do |key|
          translate_attribute(key, default: key, **options)
        end.join(', ')
      end
    end
  end
end
