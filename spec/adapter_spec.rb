require 'babysms/adapter'

RSpec.describe BabySMS::Adapter do
  around(:each) do |block|
    saved_adapters = BabySMS.adapters
    begin
      block.call
    ensure
      BabySMS.adapters = saved_adapters
    end
  end

  it 'can locate an adapter by number' do
    ad1 = BabySMS::Adapters::TestAdapter.new(from: '+15556667777')
    ad2 = BabySMS::Adapters::TestAdapter.new(from: '+15558889999')

    BabySMS.adapters = [ad1, ad2]

    expect(BabySMS::Adapter.for_number('+15556667777')).to be(ad1)
    expect(BabySMS::Adapter.for_number('+15558889999')).to be(ad2)
  end

  it 'returns nil when an adapter cannot be located by its number' do
    expect(BabySMS::Adapter.for_number('+15550001111')).to be_nil
  end

  it 'has a blank adapter_name' do
    expect(BabySMS::Adapter.adapter_name).to eq('')
  end
end
