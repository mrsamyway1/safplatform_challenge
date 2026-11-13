module SafPlatform
  class Money
    attr_reader :amount

    def initialize(amount)
      @amount = BigDecimal(amount.to_s).freeze
      raise ArgumentError, 'amount must be a finite number' unless @amount.finite?

      freeze
    end

    def self.zero
      new(0)
    end

    def self.from_cents(cents)
      new(BigDecimal(cents.to_s) / 100)
    end

    def +(other)
      raise ArgumentError, 'other must be a Money instance' unless other.is_a?(Money)

      self.class.new(amount + other.amount)
    end

    def *(other)
      raise ArgumentError, 'other must be a Numeric' unless other.is_a?(Numeric)

      self.class.new(amount * other)
    end

    def ==(other)
      return false unless other.is_a?(Money)

      amount == other.amount
    end

    def round_up_to_nearest_5_cents
      rounded_cents = (((amount * 100).ceil + 4) / 5) * 5
      self.class.from_cents(rounded_cents)
    end

    def format
      Kernel.format('%.2f', amount)
    end
  end
end
