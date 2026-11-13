module SafPlatform
  class BasketParser
    CATALOG = {
      'book' => :book, 'books' => :book,
      'music cd' => :other, 'chocolate bar' => :food,
      'box of chocolates' => :food, 'boxes of chocolates' => :food,
      'bottle of perfume' => :other, 'packet of headache pills' => :medical
    }.freeze
    CATEGORY_PATTERN = /\s+\[(book|food|medical|other)\]\z/i
    LINE_PATTERN = /\A\s*(\d+)\s+(.+?)\s+at\s+(\d+(?:\.\d{1,2})?)\s*\z/i

    def parse(input)
      items = input.lines.filter_map do |line|
        next if line.strip.empty?

        parse_line(line.strip)
      end
      raise InputError, 'basket is empty' if items.empty?

      Basket.new(items)
    end

    private

    def parse_line(line)
      match = LINE_PATTERN.match(line)
      raise InputError, "invalid basket line: #{line.inspect}" unless match

      quantity = Integer(match[1], 10)
      raise InputError, "quantity must be greater than 0: #{line.inspect}" unless quantity.positive?

      description = match[2].strip
      category_match = CATEGORY_PATTERN.match(description)
      name = category_match ? description[0...category_match.begin(0)].strip : description
      normalized_name = name.downcase
      imported = normalized_name.match?(/\bimported\b/)
      catalog_name = normalized_name.gsub(/\bimported\b/, '').split.join(' ')
      category = category_match ? category_match[1].downcase.to_sym : CATALOG[catalog_name]

      raise InputError, "unknown product: #{name.inspect}. Add a valid category such as [food], or [medical]" unless category

      product = Product.new(
        name: name,
        unit_price: Money.new(match[3]),
        imported: imported,
        category: category
      )

      BasketItem.new(product: product, quantity: quantity)
    rescue ArgumentError => e
      raise InputError, e.message
    end
  end
end
