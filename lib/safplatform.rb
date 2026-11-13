require 'bigdecimal'
require_relative 'saf_platform/domain/product'
require_relative 'saf_platform/domain/basket_item'
require_relative 'saf_platform/domain/basket'
require_relative 'saf_platform/domain/money'
require_relative 'saf_platform/domain/receipt'
require_relative 'saf_platform/tax_policy/tax_calculator'
require_relative 'saf_platform/input/basket_parser'
require_relative 'saf_platform/output/receipt_renderer'

module SafPlatform
  class InputError < StandardError; end
end
