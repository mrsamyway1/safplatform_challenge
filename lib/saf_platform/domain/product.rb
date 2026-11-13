module SafPlatform
  class Product
    attr_reader :name, :unit_price, :category

    EXEMPT_FROM_BASIC_TAX_CATEGORIES = %i[book medical food].freeze

    def initialize(name:, unit_price:, imported:, category:)
      validate_product(name, unit_price, imported, category)
      @name = name.dup.freeze
      @unit_price = unit_price
      @imported = imported
      @category = category
      freeze
    end

    def imported?
      @imported
    end

    def exempt_from_basic_tax?
      EXEMPT_FROM_BASIC_TAX_CATEGORIES.include?(category)
    end

    private

    def validate_product(name, unit_price, imported, category)
      raise ArgumentError, 'name cannot be blank' if name.to_s.strip.empty?
      raise ArgumentError, 'unit_price must be a Money instance' unless unit_price.is_a?(Money)
      raise ArgumentError, 'unit_price cannot be negative' if unit_price.amount.negative?
      raise ArgumentError, 'category must be a Symbol' unless category.is_a?(Symbol)
      raise ArgumentError, 'unknown category' unless (EXEMPT_FROM_BASIC_TAX_CATEGORIES + [:other]).include?(category)
      raise ArgumentError, 'imported must be a Boolean' unless imported == true || imported == false
    end
  end
end
