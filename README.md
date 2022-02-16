# RefinementMonkey

Monkey that manages your refinements and helps you to refine them into unique refinement modules.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "refinement-monkey"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install refinement-monkey

## Usage

```ruby
require "refinement-monkey"

Monkey = RefinementMonkey.new
Monkey.learn Array

class Mountain
  using Monkey["Array#max_of"]

  attr_reader :height

  def self.highest(*mountains)
    mountains.max_of :height
  end
end

Monkey.patches Money do
  def self.sum(moneys)
    return empty(currency || default_currency) if moneys.empty?

    first = block ? block[moneys.first] : moneys.first
    sum = (moneys.size == 1) ? first : moneys[1..].sum(first, &block)

    currency ? sum.exchange_to(currency) : sum
  end
end

class Pocket
  using Monkey/Money

  def money
    Money.sum @moneys
  end
end
```

## Development

After checking out the repository, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/boof/refinement-monkey.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
