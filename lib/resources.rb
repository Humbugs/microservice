require 'open-uri'
require 'json'
require_relative 'entities'
require_relative 'product/builder'

module Resources
  class << self
    attr_accessor :front_url

    def products
      @products ||= Product::Builder.build(parse('products', ProductEntity, 'name'))
    end

    def countries
      @countries ||= parse('countries', CountryEntity, 'iso')
    end

    def delivery_methods
      @delivery_methods ||= parse('delivery-methods', DeliveryMethodEntity, 'name')
    end

    def packing_types
      @packing_types ||= parse('packing-types', PackingTypeEntity, 'name')
    end

    def reset
      @products = nil
      @countries = nil
      @delivery_methods = nil
      @packing_types = nil
    end

    private

    def parse(url, klass, key)
      full_url = "#{front_url}/#{url}.json"

      JSON.parse(open(full_url).read).reduce({}) do |hash, element|
        hash.merge!(element[key] => klass.new(element))
      end
    end
  end
end
