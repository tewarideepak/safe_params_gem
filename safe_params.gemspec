Gem::Specification.new do |spec|
  spec.name          = "safe_params"
  spec.version       = "0.1.0"
  spec.authors       = ["Deepak Tewari"]
  spec.email         = ["tewarid69@gmail.com"]

  spec.summary       = %q{Strong parameters helper for Rails. Define permitted attributes in your model or config, with CLI support.}
  spec.description   = %q{SafeParams is a Rails gem for strong parameter handling. Define permitted attributes in your model or a YAML/JSON config. Supports nested attributes and includes a CLI for generating safe_params lines.}
  spec.homepage      = "https://github.com/tewarideepak/safe_params"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*.rb"] + ["README.md"]
  spec.require_paths = ["lib"]
  spec.bindir        = "bin"
  spec.executables   = ['safe_params']

  spec.add_dependency "rails"
  spec.add_development_dependency "rspec"

  spec.metadata = {
    "source_code_uri" => "https://github.com/tewarideepak/safe_params",
    "changelog_uri" => "https://github.com/tewarideepak/safe_params/blob/main/CHANGELOG.md",
    "bug_tracker_uri" => "https://github.com/tewarideepak/safe_params/issues"
  }
end
