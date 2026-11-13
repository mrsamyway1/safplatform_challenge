$LOAD_PATH.unshift(File.expand_path('lib', __dir__))
require 'safplatform'

def execute
  error_message = 'No input provided. Please, provide a valid input.'.freeze
  if ARGV.empty? && $stdin.tty?
    warn 'Provide a basket file or pipe basket lines to standard input'
    exit 1
  end

  input = ARGF.read
  if input.strip.empty?
    warn 'Provide basket lines on standard input or as a file argument'
    exit 1
  end

  parser = SafPlatform::BasketParser.new
  renderer = SafPlatform::ReceiptRenderer.new
  baskets = input.split(/\n\s*\n+/).reject { |basket| basket.strip.empty? }

  baskets.each_with_index do |basket_text, index|
    basket = parser.parse(basket_text)
    puts renderer.render(SafPlatform::Receipt.new(basket))
    puts if index < baskets.length - 1
  end
rescue SafPlatform::InputError => e
  warn "Input error: #{e.message}"
  exit 1
rescue SystemCallError => e
  warn "System error: #{e.message}"
  exit 1
end

execute
