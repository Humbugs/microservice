require 'order/validator'
require 'order/builder'

module Order
  describe Validator do
    let(:order) { Builder.build(JSON.parse(json_file('order'))) }

    it 'succeeds for valid order' do
      expect { Validator.validate(order) }.to_not raise_error
    end

    it 'fails if cannot pack' do
      order.basket['Wham Bar'][:quantity] = 4
      expect { Validator.validate(order) }.to raise_error(DoesNotPack)
    end

    it 'fails if delivery method not available for country' do
      order.delivery = Resources.delivery_methods['International']
      expect { Validator.validate(order) }.to raise_error(Undeliverable)
    end

    it 'fails if total does not match up' do
      order.total = BigDecimal('5.00')
      expect { Validator.validate(order) }.to raise_error(TotalMismatch)
    end
  end
end
