require_relative 'validator'

module Product
  module Builder
    class << self
      def build(products)
        products.each do |name, product|
          Validator.validate(product)
          add_density(product) unless product.purchase_option == 0
        end
      end

      private

      DENSITY_OF_WATER = 0.000998

      def add_density(product)
        volume_of_container = product.container_water_weight / DENSITY_OF_WATER
        product.density = product.container_sweets_weight / volume_of_container
      end
    end
  end
end
