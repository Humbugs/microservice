require 'order/builder'
require 'order/totaller'
require 'resources'

module Order
  describe Totaller do
    let(:order) { Builder.build(JSON.parse(json_file('order'))) }

    it 'calculates total with fixed calculator' do
      order.delivery = Resources.delivery_methods['International']
      expect(Totaller.total(order)).to eql(59.8)
    end

    it 'calculates total with percent calculator' do
      args = { 'field' => 'price', 'percent' => 20 }
      order.delivery = DeliveryMethodEntity.new(calculator: 'Percent', args: args)
      expect(Totaller.total(order)).to eql(47.76)
    end

    describe 'tiered calcualtor' do
      it 'calculates' do
        expect(Totaller.total(order)).to eql(42.18)
      end

      it 'exclusive upperbounds, inclusive lowerbounds' do
        order.basket['Bonbons'][:quantity] = 750
        expect(Totaller.total(order)).to eql(105.38)
      end

      it 'raise if not available' do
        order.basket['Bonbons'][:quantity] = 20000
        expect { Totaller.total(order) }.to raise_error(DeliveryNotApplicable)
      end
    end
  end
end
