require 'order/builder'
require 'json'

module Order
  describe Builder do
    let(:json) { JSON.parse(json_file('order')) }

    it 'build for valid order' do
      order = Builder.build(json)
      basket = {
        'Wham Bar' => { product: Resources.products['Wham Bar'], quantity: 1 },
        'Bonbons' => { product: Resources.products['Bonbons'], quantity: 250 },
        'Cola Bottles' => { product: Resources.products['Cola Bottles'], quantity: 5 }
      }
      expect(order.basket).to eql(basket)
      expect(order.address['country']).to eql(Resources.countries['PK'])
      expect(order.delivery).to eql(Resources.delivery_methods['Parcel 24'])
    end

    it 'returns failure if product not recognized' do
      json['basket'].merge!('shoe' => 1)
      expect { Builder.build(json) }.to raise_error(ProductNotFound)
    end

    it 'returns failure if country not recognized' do
      json['address'].merge!('country' => 'YOLO')
      expect { Builder.build(json) }.to raise_error(CountryNotFound)
    end

    it 'returns failure if delivery method not recognized' do
      json['delivery'] = 'Snail Mail'
      expect { Builder.build(json) }.to raise_error(DeliveryMethodNotFound)
    end
  end
end
