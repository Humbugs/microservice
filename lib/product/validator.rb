module Product
  module Validator
    class << self
      def validate(product)
        presence(product, :name)
        presence(product, :purchase_option)
        presence(product, :price)
        presence(product, :cost_price)
        case product.purchase_option
        when 0
          presence(product, :length)
          presence(product, :width)
          presence(product, :depth)
          presence(product, :weight)
        when 1
          presence(product, :container_water_weight)
          presence(product, :container_sweets_weight)
        when 2
          presence(product, :container_water_weight)
          presence(product, :container_sweets_weight)
          presence(product, :weight)
        end
      end

      private

      def presence(product, field)
        return unless product.send(field).nil?
        fail(MissingArgument, "Missing #{field} in #{product}")
      end
    end
  end
end

class MissingArgument < StandardError; end