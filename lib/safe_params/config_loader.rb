require "yaml"
require "json"

module SafeParams
  module ConfigLoader
    def self.load_for(model_name)
      file = Dir[Rails.root.join("config/safe_params.{yml,json}")].first
      return [] unless file && File.exist?(file)

      data = file.end_with?(".json") ? JSON.parse(File.read(file)) : YAML.load_file(file)
      data ||= {}
      data[model_name.to_s] || []
    end
  end
end
