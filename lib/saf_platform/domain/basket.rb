module SafPlatform
  class Basket
    include Enumerable

    def initialize(items)
      validate_items(items)
      @items = items.dup.freeze
      freeze
    end

    def each(&block)
      @items.each(&block)
    end

    private

    def validate_items(items)
      raise ArgumentError, 'basket cannot be empty' if items.empty?
      raise ArgumentError, 'basket items must be BasketItem instances' unless items.all? { |item| item.is_a?(BasketItem) }
    end
  end
end
