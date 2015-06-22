require 'box_packer'
require_relative '../resources'

module Order
  module Packer
    extend self

    def pack_all(order)
      Resources.packing_types.reduce([]) do |packings, (name, packing_type)|
        pack(order, packing_type) ? packings << name : packings
      end
    end

    def pack(order, packing_type)
      container = create_container(packing_type)

      each_item(order, packing_type) do |dimensions, weight, quantity|
        container.add_item(dimensions, weight: weight, quantity: quantity)
      end

      container.pack!
    end

    private

    def create_container(packing_type)
      BoxPacker.container(packing_type.dimensions, {
        weight_limit: packing_type.weight_limit - packing_type.weight,
        packings_limit: 1
      })
    end

    def each_item(order, packing_type)
      order.basket.each do |name, hash|
        if hash[:product].purchase_option == 0
          yield hash[:product].dimensions, hash[:product].weight, hash[:quantity]
        else
          yield *slices(packing_type, hash[:product], hash[:quantity])
        end
      end
    end

    def slices(packing_type, product, quantity)
      _, height, depth = *packing_type.dimensions
      slice_weight = height * depth * product.density
      quantity = (quantity * product.weight / slice_weight).ceil
      [[1, height, depth], quantity, slice_weight.round]
    end
  end
end
