# frozen_string_literal: true

require 'safe_params/version'
require 'rspec'

describe SafeParams do
  it 'has a version number' do
    expect(SafeParams::VERSION).not_to be_nil
  end
end
