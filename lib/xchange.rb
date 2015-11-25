require 'bigdecimal'

=begin rdoc

An instance of Xchange represents an amount of a specific currency.


=Usage

====Install
  gem install Xchange
====Require Xchange

  require 'xchange'

==== Configure the currency rates with respect to a base currency

  Xchange.conversion_rates('EUR', {'USD' => 1.11, 'Bitcoin' => 0.0047})

====Instantiate Xchange objects

  fifty_eur = Xchange.new(50, 'EUR')

====Get amount and currency

  fifty_eur.amount   # => 50

  fifty_eur.currency # => "EUR"

  fifty_eur.inspect  # => "50.00 EUR"

====Convert to a different currency

  fifty_eur.convert_to('USD') # => 55.50 USD

====Perform operations in different currencies

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


=end


class Xchange

  # Include the Comparable Mixins to implement the comparison methods
  include Comparable

  # Accessor method
  attr_reader :currency, :amount_bigdecimal

  #Creates a new Xchange object of value given by amount parameter,  with the currency given by the currency parameter
  #
  # @example
  #   Xchange.new(100, "USD") #=> "100.00 USD"
  #   Xchange.new(100, "EUR") #=> "100.00 EUR"
  def initialize (amount, currency)

    #Amount is stored in BigDecimal for better precision in currency operations
    @amount_bigdecimal = BigDecimal.new(amount,0)

    @currency = currency

  end

  #Class method that configure the currency rates with respect to a base currency
  #
  # @example
  #   Xchange.conversion_rates('EUR',{'USD' => 1.11, 'bitcoin' => 0.00047})
  def self.conversion_rates(base_currency, rates)

    @@base_currency = base_currency

    @@rates = rates

  end

  #Convenience method for amount, it returns the value in float rounded by two decimals.
  def amount

    @amount_bigdecimal.to_f.round(2)

  end

  #Convenience method that overrides the output of inspect
  def inspect

    "#{'%.02f' % (@amount_bigdecimal)} #{@currency}"

  end

  #Converts an instance to another currency
  #
  # @example
  # Xchange.new(50, 'EUR').convert_to('USD') #=> "55.50 USD"
  def convert_to(new_currency)

    # if the instance is already in the requested currency
    if @currency == new_currency

      #returns itself without conversions
      return self

    # if  the current currency is different from the base currency used for conversions
    # and also the new currency is different from the base one
    elsif @currency != @@base_currency && new_currency != @@base_currency

      # amount is divided by the rate of the current currency in order to convert it to the base currency
      # then is multiplied by the rate of the new currency
      amount = (@amount_bigdecimal/(BigDecimal(@@rates[@currency],0))) * (BigDecimal(@@rates[new_currency],0))

    # current currency is different from the base currency but new currency equals the base currency
    elsif @currency != @@base_currency && new_currency == @@base_currency

      # amount is divided by the rate of the current currency in order to convert it to the base currency
      amount = (@amount_bigdecimal  / @@rates[@currency])

    # current currency must be equal to the base currency and be different from the new currency
    else

      # amount is multiplied for the rate of the new currency
      amount = @amount_bigdecimal * (BigDecimal.new(@@rates[new_currency],0))

    end

    # A new istance is returned with the new currency and the calculated amount
    Xchange.new(amount,new_currency)

  end

  # <=> implementation allows the comparison between two Xchange instances through the Comparable mixin
  def <=>(another_currency)

    #converts the given instance in the actual currency and compares the amounts
    @amount_bigdecimal <=> another_currency.convert_to(@currency).amount_bigdecimal

  end

  # Performs an addition between the current instance and another one and
  # returns the result as a new Xchange instance
  def +(another_currency)

    #converts the given instance in the actual currency and sums the amounts
    amount = @amount_bigdecimal + another_currency.convert_to(@currency).amount

    #returns the result as a new instance
    Xchange.new(amount,@currency)

  end

  # Performs a subtraction between the current instance and another one and
  # returns the result as a new Xchange instance
  def -(another_currency)

    #converts the given instance in the actual currency and substracts the amounts
    amount= @amount_bigdecimal - another_currency.convert_to(@currency).amount

    #returns the result as a new instance
    Xchange.new(amount,@currency)

  end

  # Multiplies the amount by a given number
  def *(number)

    #performs the multiplication in BigDecimal
    amount= @amount_bigdecimal * BigDecimal(number,0)

    #returns the result as a new instance
    Xchange.new(amount,@currency)

  end

  # Divides the amount by a given number
  def /(number)

    #performs the division in BigDecimal
    amount= @amount_bigdecimal / BigDecimal(number,0)

    #returns the result as a new instance
    Xchange.new(amount,@currency)

  end


end