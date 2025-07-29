# frozen_string_literal: true

require 'safe_params/config_loader'
require 'rspec'
require 'pathname'


describe SafeParams::ConfigLoader do
  fixtures_dir = 'spec/fixtures'
  yaml_path = File.join(fixtures_dir, 'safe_params.yml')
  json_path = File.join(fixtures_dir, 'safe_params.json')
  empty_yaml_path = File.join(fixtures_dir, 'empty.yml')
  malformed_yaml_path = File.join(fixtures_dir, 'malformed.yml')

  before(:context) do
    Dir.mkdir(fixtures_dir) unless Dir.exist?(fixtures_dir)
    File.write(yaml_path, "User:\n  - name\n  - email\nAdmin:\n  - admin\n")
    File.write(json_path, '{"User": ["name", "email"], "Admin": ["admin"]}')
    File.write(empty_yaml_path, "")
    File.write(malformed_yaml_path, "User: [unclosed\n")
  end

  after(:context) do
    [yaml_path, json_path, empty_yaml_path, malformed_yaml_path].each do |f|
      File.delete(f) if File.exist?(f)
    end
    Dir.rmdir(fixtures_dir) if Dir.exist?(fixtures_dir)
  end

  before do
    stub_const('Rails', double('Rails', root: Pathname.new(File.expand_path(fixtures_dir))))
    allow(Dir).to receive(:[]).and_call_original
  end

  it 'loads params for a model from YAML' do
    allow(Dir).to receive(:[]).and_return([yaml_path])
    expect(described_class.load_for('User')).to eq(['name', 'email'])
    expect(described_class.load_for('Admin')).to eq(['admin'])
  end

  it 'loads params for a model from JSON' do
    allow(Dir).to receive(:[]).and_return([json_path])
    expect(described_class.load_for('User')).to eq(['name', 'email'])
    expect(described_class.load_for('Admin')).to eq(['admin'])
  end

  it 'returns empty array if file does not exist' do
    allow(Dir).to receive(:[]).and_return([])
    expect(described_class.load_for('User')).to eq([])
  end

  it 'returns empty array if model key is missing' do
    allow(Dir).to receive(:[]).and_return([yaml_path])
    expect(described_class.load_for('NonExistent')).to eq([])
  end

  it 'returns empty array for empty config file' do
    allow(Dir).to receive(:[]).and_return([empty_yaml_path])
    expect(described_class.load_for('User')).to eq([])
  end

  it 'raises error for malformed YAML' do
    allow(Dir).to receive(:[]).and_return([malformed_yaml_path])
    expect { described_class.load_for('User') }.to raise_error(Psych::SyntaxError)
  end

  it 'returns empty array if Rails is not defined' do
    hide_const('Rails')
    expect { described_class.load_for('User') }.to raise_error(NameError)
  end
end
