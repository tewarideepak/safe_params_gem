# frozen_string_literal: true

require 'safe_params'
require 'rspec'

describe SafeParams do
  let(:klass) do
    Class.new do
      include SafeParams
    end
  end

  it 'extends ClassMethods when included' do
    expect(klass.singleton_class.included_modules).to include(SafeParams::ClassMethods)
  end

  it 'sets and returns permitted attributes' do
    klass.safe_params(:foo, :bar, nested: { baz: [:qux] })
    expect(klass.permitted_attributes).to include(:foo, :bar)
    expect(klass.permitted_attributes.any? { |x| x.is_a?(Hash) && x[:baz] == [:qux] }).to be true
  end

  it 'handles empty attributes' do
    klass.safe_params()
    expect(klass.permitted_attributes).to eq([])
  end

  it 'handles only nested attributes' do
    klass.safe_params(nested: { foo: [:bar] })
    expect(klass.permitted_attributes).to eq([{ foo: [:bar] }])
  end
end
