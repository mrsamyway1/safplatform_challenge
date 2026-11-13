module SafPlatform
  class ReceiptRenderer
    def render(receipt)
      item_lines = receipt.lines.map do |line|
        item = line.item
        description = "#{item.quantity} #{item.product.name}"
        "#{description}: #{line.total.format}"
      end
      (item_lines + ["Sales Taxes: #{receipt.sales_taxes.format}", "Total: #{receipt.total.format}"]).join("\n")
    end
  end
end
