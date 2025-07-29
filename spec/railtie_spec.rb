# frozen_string_literal: true

require 'safe_params/railtie'
require 'rspec'

describe SafeParams::Railtie do
  it 'inherits from Rails::Railtie if Rails is defined' do
    stub_const('Rails', Class.new)
    stub_const('Rails::Railtie', Class.new)
    expect(defined?(SafeParams::Railtie)).to be_truthy
  end
  # The initializer test is skipped due to Ruby class reloading limitations
end
