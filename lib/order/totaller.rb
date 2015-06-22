require 'bigdecimal'

module Order
  class Totaller
    def self.total(*args)
      new.total(*args)
    end

    def total(order)
      @order = order
      @totals = Hash[total_fields.map { |f| [f, sum_field(f)] }]
      @totals['order'] = @totals['price']
      @totals['order'] += delivery_amount
      order.cost_total = @totals['cost_price']
      order.delivery_total = delivery_amount
      @totals['order']
    end

    private

    def total_fields
      %w(price weight cost_price)
    end

    def sum_field(field)
      @order.basket.reduce(0) do |sum, (_, hash)|
        sum + hash[:product].send(field) * hash[:quantity]
      end
    end

    def delivery_amount
      send(calculators[@order.delivery.calculator], @order.delivery.args)
    end

    def calculators
      @calculators ||=
        { 'Fixed' => :fixed, 'Percent' => :percent, 'Tiered' => :tiered }
    end

    def fixed(args)
      BigDecimal(args['amount'].to_s)
    end

    def percent(args)
      @totals[args['field']] * BigDecimal(args['percent'].to_s) / 100
    end

    def tiered(args)
      previous = nil

      args['tiers'].each do |lowerbound, amount|
        break if @totals[args['field']] < lowerbound.to_f
        previous = amount
      end

      fail(DeliveryNotApplicable, @order.delivery.name) unless previous
      BigDecimal(previous.to_s)
    end
  end
end

class DeliveryNotApplicable < StandardError; end
