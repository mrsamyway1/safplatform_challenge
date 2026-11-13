module SafPlatform
  class Receipt
    Line = Struct.new(:item, :tax, :total, keyword_init: true) do
      def initialize(**attrs)
        super
        freeze
      end
    end

    attr_reader :lines, :sales_taxes, :total

    def initialize(basket, tax_calculator: TaxCalculator.new)
      @lines = basket.map do |item|
        tax = tax_calculator.calculate_tax(item.product) * item.quantity
        Line.new(item: item, tax: tax, total: item.subtotal + tax)
      end.freeze
      @sales_taxes = lines.reduce(Money.zero) { |sum, line| sum + line.tax }
      @total = lines.reduce(Money.zero) { |sum, line| sum + line.total }
      freeze
    end
  end
end
