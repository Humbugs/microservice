require 'resources'

def json_file(resource_name)
  File.read(File.expand_path("../fixtures/#{resource_name}.json", __FILE__))
end

def stub_resource(resource_name)
  file = json_file(resource_name)
  allow(Resources).to receive(:open).with("/#{resource_name}.json")
                                    .and_return(double(read: file))
end

RSpec.configure do |c|
  c.before do
    stub_resource('countries')
    stub_resource('delivery-methods')
    stub_resource('packing-types')
    stub_resource('products')
  end
end

