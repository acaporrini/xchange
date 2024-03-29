# Xchange

A Library for dealing with currency conversion and operations between different currencies.

## Installation

    $ gem install xchange

## Usage

Require Xchange

```ruby
require 'xchange'
```

Configure the currency rates with respect to a base currency

```ruby
Xchange.conversion_rates('EUR', {'USD' => 1.11, 'Bitcoin' => 0.0047})
```
Instantiate Xchange objects
```ruby
  fifty_eur = Xchange.new(50, 'EUR')
```
Get amount and currency
```ruby
  fifty_eur.amount   # => 50

  fifty_eur.currency # => "EUR"

  fifty_eur.inspect  # => "50.00 EUR"
```
Convert to a different currency
```ruby
  fifty_eur.convert_to('USD') # => 55.50 USD
```
Perform operations in different currencies
```ruby
  twenty_dollars = Xchange.new(20, 'USD')

  # Arithmetics:

  fifty_eur + twenty_dollars # => 68.02 EUR

  fifty_eur - twenty_dollars # => 31.98 EUR

  fifty_eur / 2              # => 25 EUR

  twenty_dollars * 3         # => 60 USD

  # Comparisons (also in different currencies):

  twenty_dollars == Xchange.new(20, 'USD') # => true

  twenty_dollars == Xchange.new(30, 'USD') # => false

  fifty_eur_in_usd = fifty_eur.convert_to('USD')

  fifty_eur_in_usd == fifty_eur          # => true

  twenty_dollars > Xchange.new(5, 'USD')   # => true

  twenty_dollars < fifty_eur             # => true
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/acaporrini/xchange/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
