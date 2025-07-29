# frozen_string_literal: true

require 'safe_params/helper'
require 'rspec'

describe SafeParams::Helper do
  let(:dummy_class) do
    Class.new do
      include SafeParams::Helper
      attr_accessor :params
    end
  end
  let(:dummy) { dummy_class.new }

  let(:model_class) do
    Class.new do
      def self.name; 'User'; end
      def self.permitted_attributes; [:foo, :bar]; end
    end
  end

  before do
    dummy.params = double('params')
  end

  it 'permits params from config loader if present' do
    allow(SafeParams::ConfigLoader).to receive(:load_for).with('User').and_return([:foo, :baz])
    expect(dummy.params).to receive(:require).with(:user).and_return(dummy.params)
    expect(dummy.params).to receive(:permit).with(:foo, :baz)
    dummy.safe_params(model_class)
  end

  it 'permits model permitted_attributes if config loader is empty' do
    allow(SafeParams::ConfigLoader).to receive(:load_for).with('User').and_return([])
    expect(dummy.params).to receive(:require).with(:user).and_return(dummy.params)
    expect(dummy.params).to receive(:permit).with([:foo, :bar])
    dummy.safe_params(model_class)
  end

  it 'symbolizes deeply nested arrays and hashes' do
    arr = [{ 'a' => [{ 'b' => 'c' }] }]
    result = dummy.send(:symbolize_deep, arr)
    expect(result).to eq([{ a: [{ b: 'c' }] }])
  end

  it 'handles empty config loader result' do
    allow(SafeParams::ConfigLoader).to receive(:load_for).and_return([])
    expect(dummy.params).to receive(:require).with(:user).and_return(dummy.params)
    expect(dummy.params).to receive(:permit).with([:foo, :bar])
    dummy.safe_params(model_class)
  end

  it 'handles nil config loader result' do
    allow(SafeParams::ConfigLoader).to receive(:load_for).and_return(nil)
    expect(dummy.params).to receive(:require).with(:user).and_return(dummy.params)
    expect(dummy.params).to receive(:permit).with([:foo, :bar])
    dummy.safe_params(model_class)
  end

  it 'handles model with no permitted_attributes' do
    klass = Class.new { def self.name; 'User'; end }
    allow(SafeParams::ConfigLoader).to receive(:load_for).and_return([])
    expect(dummy.params).to receive(:require).with(:user).and_return(dummy.params)
    expect(dummy.params).to receive(:permit).with(nil)
    dummy.safe_params(klass)
  end
end

