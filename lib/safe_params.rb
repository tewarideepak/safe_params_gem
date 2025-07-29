require "safe_params/version"
require "safe_params/railtie" if defined?(Rails)
require "safe_params/helper"
require "safe_params/config_loader"
require "safe_params/cli"

module SafeParams
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def safe_params(*attrs, nested: {})
      @safe_attrs = attrs.map(&:to_sym)
      @nested_attrs = nested.transform_keys(&:to_sym)
    end

    def permitted_attributes
      nested = @nested_attrs.map { |key, val| { key => val } }
      @safe_attrs + nested
    end
  end
end
