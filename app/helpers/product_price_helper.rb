module Spree
  module ProductPriceHelper
    def self.cost_price(product_or_variant)
      Spree::Price.new(variant_id: product_or_variant.id, currency: product_or_variant.currency, price: product_or_variant.cost_price).display_price.to_html
    end

    def self.percentage_profit(product_or_variant)
      (((product_or_variant.cost_price - product_or_variant.price_in(product_or_variant.currency).price) / product_or_variant.cost_price) * 100).round(2)
    end
  end
end
