require_relative '../spec_helper'

RSpec.describe SafPlatform::Receipt do
  it 'calculates and renders a basket with taxable and exempt products correctly' do
    input = <<~BASKET
      2 book at 12.49
      1 music CD at 14.99
      1 chocolate bar at 0.85
    BASKET
    basket = SafPlatform::BasketParser.new.parse(input)
    receipt = SafPlatform::Receipt.new(basket)

    expect(SafPlatform::ReceiptRenderer.new.render(receipt)).to eq(<<~RECEIPT.chomp)
      2 book: 24.98
      1 music CD: 16.49
      1 chocolate bar: 0.85
      Sales Taxes: 1.50
      Total: 42.32
    RECEIPT
  end

  it 'calculates and renders a basket with imported products correctly' do
    input = <<~BASKET
      1 imported box of chocolates at 10.00
      1 imported bottle of perfume at 47.50
    BASKET
    basket = SafPlatform::BasketParser.new.parse(input)
    receipt = SafPlatform::Receipt.new(basket)

    expect(SafPlatform::ReceiptRenderer.new.render(receipt)).to eq(<<~RECEIPT.chomp)
      1 imported box of chocolates: 10.50
      1 imported bottle of perfume: 54.65
      Sales Taxes: 7.65
      Total: 65.15
    RECEIPT
  end

  it 'calculates and renders a basket with multiple imported products correctly' do
    input = <<~BASKET
      1 imported bottle of perfume at 27.99
      1 bottle of perfume at 18.99
      1 packet of headache pills at 9.75
      3 imported boxes of chocolates at 11.25
    BASKET
    basket = SafPlatform::BasketParser.new.parse(input)
    receipt = SafPlatform::Receipt.new(basket)

    expect(SafPlatform::ReceiptRenderer.new.render(receipt)).to eq(<<~RECEIPT.chomp)
      1 imported bottle of perfume: 32.19
      1 bottle of perfume: 20.89
      1 packet of headache pills: 9.75
      3 imported boxes of chocolates: 35.55
      Sales Taxes: 7.90
      Total: 98.38
    RECEIPT
  end

  it 'rounds tax per unit before multiplying by quantity' do
    basket = SafPlatform::BasketParser.new.parse('3 music CD at 0.51')
    receipt = described_class.new(basket)

    expect(receipt.sales_taxes).to eq(SafPlatform::Money.new('0.30'))
    expect(receipt.total).to eq(SafPlatform::Money.new('1.83'))
  end
end
