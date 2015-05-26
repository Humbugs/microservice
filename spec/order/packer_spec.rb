require 'order/packer'
require 'order/builder'

module Order
  describe Packer do
    let(:order) { Builder.build(JSON.parse(json_file('order'))) }

    after { Resources.reset }

    it 'packs' do
      expect(Packer.pack_all(order)).to eql('Large Letter' => 1, 'Parcel' => 1)
    end

    it 'does not pack item too large' do
      Resources.products['Wham Bar'].depth = 50
      expect(Packer.pack_all(order)).to eql('Large Letter' => nil, 'Parcel' => 1)
    end

    it 'needs multiple packings when items too heavy' do
      order.basket['Cola Bottles'][:quantity] = 13
      expect(Packer.pack_all(order)).to eql('Large Letter' => 2, 'Parcel' => 1)
    end

    it 'needs multiple packings when too many items to fit' do
      order.basket['Wham Bar'][:quantity] = 4
      expect(Packer.pack_all(order)).to eql('Large Letter' => 2, 'Parcel' => 2)
    end
  end
end
