require 'virtus'
require 'bigdecimal'
require 'securerandom'

class OrderEntity
  include Virtus.model
  attribute :number, String, default: SecureRandom.hex(8).upcase
  attribute :basket, Hash[String => Integer]
  attribute :customer, Hash
  attribute :address, Hash
  attribute :delivery, String
  attribute :token, String
  attribute :currency, String
  attribute :total, BigDecimal
  attribute :cost_total, BigDecimal
  attribute :delivery_total, BigDecimal
end

class ProductEntity
  include Virtus.model
  attribute :name, String
  attribute :purchase_option, Integer
  attribute :price, BigDecimal
  attribute :cost_price, BigDecimal
  attribute :container_water_weight, Integer
  attribute :container_sweets_weight, Integer
  attribute :width, Integer
  attribute :height, Integer
  attribute :depth, Integer
  attribute :weight, Integer
  attr_accessor :density

  def dimensions
    [width, height, depth]
  end
end

class CountryEntity
  include Virtus.model
  attribute :iso, String
  attribute :name, String
  attribute :zones, Array[String]
end

class DeliveryMethodEntity
  include Virtus.model
  attribute :name, String
  attribute :zones, Array[String]
  attribute :calculator, String
  attribute :args, Hash
  attribute :eta, String
  attribute :packing_type
end

class PackingTypeEntity
  include Virtus.model
  attribute :name, String
  attribute :width, Integer
  attribute :height, Integer
  attribute :depth, Integer
  attribute :weight_limit, Integer
  attribute :weight, Integer

  def dimensions
    [width, height, depth]
  end
end
