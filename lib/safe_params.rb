
require "safe_params/version"
require "safe_params/railtie" if defined?(Rails)
require "safe_params/helper"
require "safe_params/config_loader"
require "safe_params/cli"

module SafeParams
  extend ActiveSupport::Concern

  included do
    class_attribute :_safe_attrs, instance_writer: false, default: []
    class_attribute :_nested_attrs, instance_writer: false, default: {}
  end

  class_methods do
    def safe_params(*attrs, nested: {})
      self._safe_attrs = attrs.map(&:to_sym)
      self._nested_attrs = nested.transform_keys(&:to_sym)
    end

    def permitted_attributes
      nested = _nested_attrs.map { |key, val| { key => val } }
      _safe_attrs + nested
    end
  end
end

# Automatically include SafeParams in ActiveRecord models
ActiveSupport.on_load(:active_record) do
  include SafeParams
end
