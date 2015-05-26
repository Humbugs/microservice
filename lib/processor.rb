require_relative 'order/builder'
require_relative 'order/packer'
require_relative 'order/validator'
require_relative 'payment'
require_relative 'mailer'

module Processor
  class << self
    def process(json)
      order = Order::Builder.build(json)
      packings = Order::Packer.pack(order, order.delivery.packing_type)
      Order::Validator.validate(order, packings)
      Payment.create(order)
      Mailer.record(order)
      Mailer.confirm(order)
      order
    end
  end
end
