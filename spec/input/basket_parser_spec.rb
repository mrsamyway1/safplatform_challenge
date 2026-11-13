require_relative '../spec_helper.rb'

RSpec.describe SafPlatform::BasketParser do
  subject(:parser) { described_class.new }

  it 'parses quantity, price, category and import status' do
    basket = parser.parse("2 imported box of chocolates at 11.25\n1 music CD at 14.99")
    item = basket.first

    expect(item.quantity).to eq(2)
    expect(item.product.name).to eq('imported box of chocolates')
    expect(item.product.unit_price).to eq(SafPlatform::Money.new('11.25'))
    expect(item.product.imported?).to be true
    expect(item.product.category).to eq(:food)
  end

  it 'accepts an explicit category for an unknown product' do
    item = parser.parse('1 burger [food] at 5.00').first

    expect(item.product.name).to eq('burger')
    expect(item.product.category).to eq(:food)
  end

  it 'rejects a malformed basket line' do
    expect { parser.parse('//') }.to raise_error(SafPlatform::InputError, /invalid basket line/)
  end

  it 'rejects an empty basket' do
    expect { parser.parse(" \n") }.to raise_error(SafPlatform::InputError, /basket is empty/)
  end

  it 'rejects a zero quantity item' do
    expect { parser.parse('0 book at 12.49') }.to raise_error(SafPlatform::InputError, /quantity must be greater than 0/)
  end

  it 'rejects an unknown product without a category' do
    expect { parser.parse('1 unknown product at 10.00') }.to raise_error(SafPlatform::InputError, /unknown product/)
  end
end
