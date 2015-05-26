require 'order/validator'
require 'order/builder'

module Order
  describe Validator do
    let(:order) { Builder.build(JSON.parse(json_file('order'))) }

    it 'succeeds for valid order' do
      expect { Validator.validate(order, 1) }.to_not raise_error
    end

    it 'fails if packings nil' do
      expect { Validator.validate(order, nil) }.to raise_error(Undeliverable)
    end

    it 'fails if delivery method not available for country' do
      order.delivery = Resources.delivery_methods['International']
      expect { Validator.validate(order, 1) }.to raise_error(Undeliverable)
    end

    it 'fails if total does not match up' do
      order.total = BigDecimal('5.00')
      expect { Validator.validate(order, 1) }.to raise_error(TotalMismatch)
    end

  end
end
