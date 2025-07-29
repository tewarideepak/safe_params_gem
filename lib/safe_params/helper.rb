module SafeParams
  module Helper
    def safe_params(model)
      name = model.name.underscore
      config_params = SafeParams::ConfigLoader.load_for(model.name)

      if Array(config_params).any?
        params.require(name.to_sym).permit(*symbolize_deep(config_params))
      else
        permitted = model.respond_to?(:permitted_attributes) ? model.permitted_attributes : nil
        params.require(name.to_sym).permit(permitted)
      end
    end

    private

    def symbolize_deep(obj)
      case obj
      when Hash then obj.transform_keys(&:to_sym).transform_values { |v| symbolize_deep(v) }
      when Array then obj.map { |e| symbolize_deep(e) }
      else obj
      end
    end
  end
end
