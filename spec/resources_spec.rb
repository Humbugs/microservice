require 'resources'

describe Resources do
  it 'parses json and returns lookup of entities' do
    expect(Resources.countries['JM'].name).to eql('Jamaica')
    expect(Resources.countries['PK'].name).to eql('Pakistan')
    expect(Resources.countries['LK'].name).to eql('Sri Lanka')
  end

  it 'builds products' do
    expect(Resources.products['Bonbons'].density).to eql(0.0005918498367791077)
  end
end
