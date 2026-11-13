# SafPlatform Sales tax receipt

A Ruby application that calculates sales tax for shopping baskets and prints the receipts.

## Dependencies

- **Bigdecimal** Ruby bundled library used for decimal arithmetic. `It is declared in the Gemfile so Bundler can load it.`
- **RSpec** to run the tests.

## Requirements

- Ruby 4.0.9
- Bundler

## Run with Docker

Build the image:
```sh
docker build -t sales-tax .
```

Run the provided basket file:
```sh
docker run --rm sales-tax baskets.txt
```
Or provide input through standard input:
```sh
printf '2 book at 12.49\n1 music CD at 14.99\n 1 chocolate bar at 0.85\n' | docker run --rm -i sales-tax
```

## Run Locally

Install dependencies:
```sh
bundle install
```

Calculate and print receipt:
```sh
ruby app.rb baskets.txt
```
Or through standard input:
```sh
ruby app.rb <<'BASKET'
2 book at 12.49
1 music CD at 14.99
1 chocolate bar at 0.85

1 imported box of chocolates at 10.00
1 imported bottle of perfume at 47.50

1 imported bottle of perfume at 27.99
1 bottle of perfume at 18.99
1 packet of headache pills at 9.75
3 imported boxes of chocolates at 11.25
BASKET
```


## Run tests with Docker

```sh
docker run --rm --entrypoint bundle sales-tax exec rspec
```

## Assumptions

- Products that are not included in the catalog require a category for being processed (e.g.: `1 apple [food] at 2.34`)
- A provided category overrides the product's catalog category (Supported categories are `book`, `food`, `medical`, and `other`)
- A product is considered imported if its name contains the word `imported`.
