module SafPlatform
  class TaxCalculator
    BASIC_TAX_RATE = BigDecimal('0.10')
    IMPORT_DUTY_RATE = BigDecimal('0.05')

    def calculate_tax(product)
      rate = BigDecimal('0')
      rate += BASIC_TAX_RATE unless product.exempt_from_basic_tax?
      rate += IMPORT_DUTY_RATE if product.imported?

      (product.unit_price * rate).round_up_to_nearest_5_cents
    end
  end
end
