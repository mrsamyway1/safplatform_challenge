module SafPlatform
  class BasketItem
    attr_reader :product, :quantity

    def initialize(product:, quantity:)
      validate_product(product: product, quantity: quantity)

      @product = product
      @quantity = quantity
      freeze
    end

    def subtotal
      product.unit_price * quantity
    end

    private

    def validate_product(product:, quantity:)
      raise ArgumentError, 'product must be a Product instance' unless product.is_a?(Product)
      raise ArgumentError, 'quantity must be a positive integer' unless quantity.is_a?(Integer) && quantity.positive?
    end
  end
end
