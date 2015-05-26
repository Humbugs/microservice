require_relative '../resources'
require_relative '../entities'

module Order
  module Builder
    class << self
      def build(json)
        order = OrderEntity.new(json)
        build_products(order)
        build_country(order)
        build_delivery(order)
        order
      end

      def build_basket(json)
        order = OrderEntity.new(json)
        build_products(order)
        order
      end

      private

      def build_products(order)
        order.basket = order.basket.map do |name, quantity|
          product = Resources.products[name]
          fail(ProductNotFound, name) unless product
          [name, { product: product, quantity: quantity }]
        end
      end

      def build_country(order)
        iso = order.address['country']
        order.address['country'] = Resources.countries[iso]
        fail(CountryNotFound, iso) unless order.address['country']
      end

      def build_delivery(order)
        method_name = order.delivery
        order.delivery = Resources.delivery_methods[method_name]
        fail(DeliveryMethodNotFound, method_name) unless order.delivery
      end
    end
  end
end

class ProductNotFound < StandardError; end
class CountryNotFound < StandardError; end
class DeliveryMethodNotFound < StandardError; end
