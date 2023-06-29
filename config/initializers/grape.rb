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

module ParamsDsl
  extend ActiveSupport::Concern

  def string_field(field, opts = {})
    opts                    = default_opts(field).merge(opts)
    opts[:type]             = String
    opts[:max_length]       ||= GRAPE_API::MAX_STRING_LENGTH
    opts[:sensitive_filter] ||= true

    if opts[:en]
      opts.delete(:en)
      opts[:regexp]           = GRAPE_API::EN_REGEX
      opts[:sensitive_filter] ||= false # 英文不需要过滤
    end

    render_field(field, opts)
  end

  def text_field(field, opts = {})
    opts                    = default_opts(field).merge(opts)
    opts[:type]             = String
    opts[:max_length]       ||= GRAPE_API::MAX_TEXT_LENGTH
    opts[:sensitive_filter] ||= true

    render_field(field, opts)
  end

  def email_field(field, opts = {})
    opts[:regexp] = GRAPE_API::EMAIL_REGEX
    string_field field, opts
  end

  def date_field(field, opts = {})
    opts        = default_opts(field).merge(opts)
    opts[:type] = Date

    render_field(field, opts)
  end

  def date_time_field(field, opts = {})
    opts        = default_opts(field).merge(opts)
    opts[:type] = DateTime

    render_field(field, opts)
  end

  def password_field(field, opts = {})
    opts[:regexp] ||= GRAPE_API::PASSWD_REGEX
    string_field field, opts
  end

  def integer_field(field, opts = {})
    opts        = default_opts(field).merge(opts)
    opts[:type] = Integer

    render_field(field, opts)
  end

  def bool_field(field, opts = {})
    opts        = default_opts(field).merge(opts)
    opts[:type] = Grape::API::Boolean

    render_field(field, opts)
  end

  def enum_field(field, opts = {})
    opts          = default_opts(field).merge(opts)
    opts[:type]   = String
    opts[:values] ||= default_values(field)

    render_field(field, opts)
  end

  def multi_enum_field(field, opts = {})
    opts          = default_opts(field).merge(opts)
    opts[:type]   = Array
    opts[:values] ||= default_values(field)

    render_field(field, opts)
  end

  def auto_field(field, opts = {})
    opts = default_opts(field).merge(opts)
    render_field(field, opts)
  end

  def default_opts(field)
    {
      desc:        I18n.t_activerecord(element, field),
      allow_blank: false
    }
  end

  def default_values(field)
    glass = element.to_s.classify.safe_constantize
    return unless glass

    field = field.to_s.pluralize
    glass.send(field).keys
  end

  def render_field(field, opts)
    if opts[:optional] || opts[:default]
      opts.delete(:optional)
      opts[:allow_blank] = true

      optional field, opts
    else
      requires field, opts
    end
  end
end

class Grape::Validations::ParamsScope
  include ParamsDsl
end
