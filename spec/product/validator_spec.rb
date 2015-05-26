require 'product/validator'
require 'entities'

module Product
  describe Validator do
    let!(:products) { JSON.parse(json_file('products')) }
    let(:product_json) { products[0] }

    def passes
      product = ProductEntity.new(product_json)
      expect { Validator.validate(product) }.to_not raise_error
    end

    def check_presence(field)
      product_json.delete(field)
      product = ProductEntity.new(product_json)
      expect { Validator.validate(product) }.to raise_error(MissingArgument)
    end

    it('passes') { passes }
    it('checks name')            { check_presence('name')            }
    it('checks purchase_option') { check_presence('purchase_option') }
    it('checks price')           { check_presence('price')           }
    it('checks cost_price')      { check_presence('cost_price')      }
    it('checks length')          { check_presence('length')          }
    it('checks width')           { check_presence('width')           }
    it('checks depth')           { check_presence('depth')           }
    it('checks weight')          { check_presence('weight')          }

    context 'with priced by weight' do
      let(:product_json) { products[1] }
      it('passes') { passes }
      it('checks water weight')  { check_presence('container_water_weight')  }
      it('checks sweets weight') { check_presence('container_sweets_weight') }
    end

    context 'with pick n mix' do
      let(:product_json) { products[2] }
      it('passes') { passes }
      it('checks water weight')  { check_presence('container_water_weight')  }
      it('checks sweets weight') { check_presence('container_sweets_weight') }
      it('checks weight')        { check_presence('weight')                  }
    end
  end
end
