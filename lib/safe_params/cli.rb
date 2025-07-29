require 'thor'

# Command-line interface for SafeParams
module SafeParams
  class CLI < Thor
    desc "generate MODEL", "Print a safe_params line for the given ActiveRecord model."
    def generate(model_name)
      model_class = Object.const_get(model_name)
      unless model_class.respond_to?(:columns)
        warn "Model '#{model_name}' does not support .columns. Is it an ActiveRecord model?"
        exit(1)
      end
      columns = model_class.columns.reject { |c| %w[id created_at updated_at].include?(c.name) }
      if columns.empty?
        puts "safe_params"
      else
        keys = columns.map { |c| c.name.to_sym }
        puts "safe_params #{keys.map(&:inspect).join(', ')}"
      end
    rescue NameError
      warn "Model '#{model_name}' not found. Please check the model name."
      exit(1)
    rescue => e
      warn "Unexpected error: #{e.class}: #{e.message}"
      exit(1)
    end

    desc "version", "Show SafeParams version"
    def version
      require 'safe_params/version'
      puts "SafeParams v#{SafeParams::VERSION}"
    end
  end
end
