require_relative '../spec_helper'

RSpec.describe SafPlatform::Product do
  let(:attributes) { { name: 'dasd', unit_price: SafPlatform::Money.new('1'), imported: false, category: :food } }
  it 'rejects a product with a blank name' do
    expect { described_class.new(**attributes.merge(name: '')) }.to raise_error(ArgumentError)
  end

  it 'rejects a product with a negative unit price' do
    expect { described_class.new(**attributes.merge(unit_price: SafPlatform::Money.new('-10'))) }.to raise_error(ArgumentError)
  end

  it 'rejects a product with an unknown category' do
    expect { described_class.new(**attributes.merge(category: :unknown)) }.to raise_error(ArgumentError)
  end

  it 'rejects a product with a non-boolean imported value' do
    expect { described_class.new(**attributes.merge(imported: nil)) }.to raise_error(ArgumentError)
  end

  it 'accepts a valid product' do
    product = described_class.new(**attributes)
    expect(product.name).to eq('dasd')
    expect(product.unit_price).to eq(SafPlatform::Money.new('1'))
    expect(product.imported?).to be false
    expect(product.category).to eq(:food)
  end

  it 'correctly identifies exempt products' do
    exempt_product = described_class.new(**attributes.merge(category: :book))
    non_exempt_product = described_class.new(**attributes.merge(category: :other))
    expect(exempt_product.exempt_from_basic_tax?).to be true
    expect(non_exempt_product.exempt_from_basic_tax?).to be false
  end
end
