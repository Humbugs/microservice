require 'processor'

describe Processor do
  let(:order) { double(delivery: double(packing_type: nil)) }

  it 'processes' do
    expect(Order::Builder).to receive(:build).and_return(order)
    expect(Order::Packer).to receive(:pack)
    expect(Order::Validator).to receive(:validate)
    expect(Payment).to receive(:create).with(order)
    expect(Mailer).to receive(:record).with(order)
    expect(Mailer).to receive(:confirm).with(order)
    expect(Processor.process({})).to be(order)
  end
end
