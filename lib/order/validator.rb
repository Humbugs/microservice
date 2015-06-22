require_relative 'totaller'
require_relative 'packer'

module Order
  module Validator
    class << self
      def validate(order)
        packs(order, order.delivery.packing_type) if order.delivery.packing_type
        delivery_available(order)
        total_matches(order)
      end

      private

      def packs(order, packing_type)
        fail(DoesNotPack, order.delivery.name) unless Order::Packer.pack(order, packing_type)
      end

      def delivery_available(order)
        fail(Undeliverable, order.delivery.name) unless address_available?(order)
      end

      def address_available?(order)
        (order.address['country'].zones & order.delivery.zones).any?
      end

      def total_matches(order)
        fail(TotalMismatch, order.total.to_f) if Totaller.total(order) != order.total
      end
    end
  end
end

class DoesNotPack < StandardError; end
class Undeliverable < StandardError; end
class TotalMismatch < StandardError; end
