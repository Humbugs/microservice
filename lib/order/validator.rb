require_relative 'totaller'

module Order
  module Validator
    class << self
      def validate(order, packings)
        delivery_available(order, packings)
        total_matches(order, packings)
      end

      private

      def delivery_available(order, packings)
        return if packings && address_available?(order)
        fail Undeliverable, order.delivery.name
      end

      def address_available?(order)
        (order.address['country'].zones & order.delivery.zones).any?
      end

      def total_matches(order, packings)
        return unless Totaller.total(order, packings) != order.total
        fail TotalMismatch, order.total.to_f
      end
    end
  end
end

class Undeliverable < StandardError; end
class TotalMismatch < StandardError; end
