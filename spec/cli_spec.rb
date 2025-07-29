# frozen_string_literal: true

require 'safe_params/cli'
require 'rspec'
require 'ostruct'

describe SafeParams::CLI do
  let(:cli) { SafeParams::CLI.new }

  class DummyModel
    def self.columns
      [OpenStruct.new(name: 'id'), OpenStruct.new(name: 'foo'), OpenStruct.new(name: 'bar'), OpenStruct.new(name: 'created_at'), OpenStruct.new(name: 'updated_at')]
    end
  end

  before do
    stub_const('DummyModel', DummyModel)
  end

  it 'prints safe_params line for a valid model' do
    expect { cli.generate('DummyModel') }.to output(/safe_params :foo, :bar/).to_stdout
  end

  it 'handles model not found error' do
    expect { cli.generate('NonExistentModel') }.to output(/Error: uninitialized constant NonExistentModel/).to_stdout
  end

  it 'handles model with no columns' do
    stub_const('EmptyModel', Class.new { def self.columns; []; end })
    expect { cli.generate('EmptyModel') }.to output(/safe_params/).to_stdout
  end

  it 'handles model with only reserved columns' do
    stub_const('ReservedModel', Class.new { def self.columns; [OpenStruct.new(name: 'id'), OpenStruct.new(name: 'created_at'), OpenStruct.new(name: 'updated_at')]; end })
    expect { cli.generate('ReservedModel') }.to output(/safe_params/).to_stdout
  end

  it 'prints error for unexpected exception' do
    allow(Object).to receive(:const_get).and_raise(StandardError, 'fail')
    expect { cli.generate('AnyModel') }.to output(/Error: fail/).to_stdout
  end
end
