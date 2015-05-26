require 'product/builder'
require 'entities'
require 'json'

module Product
  describe Builder do
    let(:products) do
      parsed = JSON.parse(json_file('products'))
      {
        'Wham Bar' => ProductEntity.new(parsed[0]),
        'Bonbons' => ProductEntity.new(parsed[1]),
        'Cola Bottles' => ProductEntity.new(parsed[2])
      }
    end

    it 'builds' do
      result = Builder.build(products)

      expect(result['Wham Bar'].price).to eql(7.30)
      expect(result['Wham Bar'].weight).to eql(95)
      expect(result['Wham Bar'].density).to be(nil)

      expect(result['Bonbons'].price).to eql(0.125)
      expect(result['Bonbons'].weight).to eql(1)
      expect(result['Bonbons'].density).to eql(0.0005918498367791077)

      expect(result['Cola Bottles'].price).to eql(0.25)
      expect(result['Cola Bottles'].weight).to eql(33)
      expect(result['Cola Bottles'].density).to eql(0.0006765549510337323)
    end

  end
end