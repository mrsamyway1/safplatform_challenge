require_relative '../spec_helper'

RSpec.describe SafPlatform::TaxCalculator do
  subject(:calculator) { described_class.new }

  def product(price:, category:, imported: false)
    SafPlatform::Product.new(
      name: 'test',
      unit_price: SafPlatform::Money.new(price),
      category: category,
      imported: imported
    )
  end

  it 'rounds tax up to the nearest 0.05' do
    expect(calculator.calculate_tax(product(price: '47.50', category: :other, imported: true))).to eq(SafPlatform::Money.new('7.15'))
  end

  it 'calculates tax for taxable and exempt products' do
    product1 = product(price: '14.99', category: :other, imported: false)
    product2 = product(price: '12.49', category: :book, imported: false)
    product3 = product(price: '10.00', category: :food, imported: true)

    expect(calculator.calculate_tax(product1)).to eq(SafPlatform::Money.new('1.50'))
    expect(calculator.calculate_tax(product2)).to eq(SafPlatform::Money.new('0.00'))
    expect(calculator.calculate_tax(product3)).to eq(SafPlatform::Money.new('0.50'))
  end

  it 'charges import duty for imported products' do
    product = product(price: '14.99', category: :other, imported: true)
    expect(calculator.calculate_tax(product)).to eq(SafPlatform::Money.new('2.25'))
  end

  it 'combines basic tax and import ducy before rounding' do
    result = calculator.calculate_tax(product(price: '0.10', category: :other, imported: true))
    expect(result).to eq(SafPlatform::Money.new('0.05'))
  end

  it 'rounds at five cent boundaries without increasing an exact bounday' do
    expect(calculator.calculate_tax(product(price: '0.49', category: :other, imported: false))).to eq(SafPlatform::Money.new('0.05'))
    expect(calculator.calculate_tax(product(price: '0.50', category: :other, imported: false))).to eq(SafPlatform::Money.new('0.05'))
    expect(calculator.calculate_tax(product(price: '0.51', category: :other, imported: false))).to eq(SafPlatform::Money.new('0.10'))
  end
end
