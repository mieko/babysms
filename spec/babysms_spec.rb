RSpec.describe BabySMS do
  it 'has a version number' do
    expect(BabySMS::VERSION).not_to be nil
  end

  it 'uses a verbose test adapter by default' do
    expect(BabySMS.adapter).to be_kind_of(BabySMS::Adapters::TestAdapter)
    expect(BabySMS.adapter.verbose).to be_truthy
  end
end
