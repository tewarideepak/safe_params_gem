# SafeParams

A Rails gem that simplifies strong parameter handling by defining permitted attributes in the model.

## Features

- Define strong parameters in the model
- Supports nested attributes
- Load attributes from a YAML or JSON config
- CLI generator for auto-generating safe_params lines

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'safe_params'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install safe_params
```

## Usage

### In the Model

```ruby
class User < ApplicationRecord
  include SafeParams
  safe_params :name, :email, nested: { address_attributes: [:city, :zip] }
end
```

### In the Controller

```ruby
def user_params
  safe_params(User)
end
```

### YAML Config (Optional)

`config/safe_params.yml`

```yaml
User:
  - name
  - email
  - address_attributes:
      - city
      - zip
```

### CLI Generator

```bash
bundle exec ruby -Ilib -r safe_params/cli -e "SafeParams::CLI.start(['generate', 'User'])"
```

Output:

```ruby
safe_params :name, :email, :address_attributes => [:city, :zip]
```

## CLI Usage

After installing the gem, you can use the CLI to generate a `safe_params` line for any ActiveRecord model:

```bash
safe_params generate User
```

Output:

```
safe_params :name, :email, :address_attributes
```

Show the gem version:

```bash
safe_params version
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/tewarideepak/safe_params_gem](https://github.com/tewarideepak/safe_params_gem).

## License

This project is licensed under the MIT License.
