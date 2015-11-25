require 'spec_helper'

describe Xchange do

  before do
    Xchange.conversion_rates('EUR',{
      'USD' => 1.11,
      'Bitcoin' => 0.0047
    })
    @fifty_eur = Xchange.new(50,'EUR')
    @twenty_dollars = Xchange.new(20, 'USD')
    @twentyfive_bitcoin = Xchange.new(25, 'Bitcoin')
  end

  it 'has a version number' do
    expect(Xchange::VERSION).not_to be nil
  end

  context 'Istantiate correctly' do

    it 'returns the correct amount' do
      expect(@fifty_eur.amount).to eq(50)
    end

    it 'returns the correct currency' do
      expect(@fifty_eur.currency).to eq('EUR')
    end

    it ' formats inspect output correctly' do
      expect(@fifty_eur.inspect).to eq('50.00 EUR')
    end

  end

  context 'Converts from the base currency to another one' do

    it 'converts the currency' do
      expect(@fifty_eur.convert_to('USD').currency).to eq('USD')
    end

    it 'converts the amount' do
      expect(@fifty_eur.convert_to('USD').amount).to eq(55.50)
    end

    it 'returns an istance of Xchange' do
      expect(@fifty_eur.convert_to('USD')).to  be_a_kind_of(Xchange)
    end

  end

  context 'Converts from a different currency to the base one' do

    it 'converts the currency' do
      expect(@twenty_dollars.convert_to('EUR').currency).to eq('EUR')
    end

    it 'converts the amount' do
      expect(@twenty_dollars.convert_to('EUR').amount).to eq(18.02)
    end

  end

  context 'convert between currencies that are different from the base one' do

    it 'converts the currency' do
      expect(@twenty_dollars.convert_to('Bitcoin').currency).to eq('Bitcoin')
    end

    it 'converts the amount' do
      expect(@twenty_dollars.convert_to('Bitcoin').amount).to eq(0.08)
    end

  end

  context 'Performs operations in different currencies' do

    it 'sums with an istance with a different currency' do
      expect((@fifty_eur + @twenty_dollars).amount).to eq(68.02)
    end

    it 'substracts to an instance with a different currency' do
      expect((@fifty_eur - @twenty_dollars).amount).to eq(31.98)
    end

    it 'multiplies for a number' do
      expect((@twenty_dollars * 3 ).amount).to eq(60)
    end

    it 'divides for a number' do
      expect((@fifty_eur / 2 ).amount).to eq(25)
    end

  end

  context 'Comparison' do

    before do
      @fifty_eur_in_usd = @fifty_eur.convert_to('USD')
    end


    it 'equals to an other instance with same values' do
      expect(@twenty_dollars == Xchange.new(20,'USD')).to eq(true)
    end

    it 'is not equal to an instance with a different amount' do
      expect(@twenty_dollars).not_to eq(Xchange.new(30,'USD'))
    end

    it 'is equal to an instance with same amount in a different currency' do
      test =  @fifty_eur_in_usd == @fifty_eur
      expect(test).to eq(true)
    end

    it 'is lower than an instance with a higher amount' do
      expect(@twenty_dollars < @fifty_eur).to eq(true)
    end

    it 'is greater than an instance with a lower amount' do
      expect(@twenty_dollars > Xchange.new(5, 'USD')).to eq(true)
    end


   end



end
