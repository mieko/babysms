require 'babysms/message'

RSpec.describe BabySMS::Message do
  subject(:message) do
    BabySMS::Message.new(recipient: '+1 555-555-5555', contents: 'Hello, world')
  end

  let(:good_adapter) do
    BabySMS::Adapters::TestAdapter.new(fails: false)
  end

  let(:bad_adapter) do
    BabySMS::Adapters::TestAdapter.new(fails: true)
  end

  it 'calls deliver on the configured adapter' do
    expect(BabySMS.adapter).to receive(:deliver)
    message.deliver
  end

  it 'does not attempt to deliver to invalid recipients' do
    message.recipient = '5'
    expect { message.deliver }.to raise_error(BabySMS::InvalidMessage)
  end

  it 'attempts all adapters until success' do
    expect(bad_adapter).to receive(:deliver).ordered.once.and_call_original
    expect(good_adapter).to receive(:deliver).ordered.once.and_call_original

    message.deliver(adapters: [bad_adapter, good_adapter])
  end

  it 'raises an error if all adapters fail' do
    expect { message.deliver(adapters: [bad_adapter]) }.to raise_error(BabySMS::FailedDelivery)
  end

  it 'doesnt raise an error if any adapter succeeds' do
    expect { message.deliver(adapters: [bad_adapter, good_adapter]) }.not_to raise_error
  end

  it 'collects earlier adapter errors on successful delivery' do
    result = message.deliver(adapters: [bad_adapter, good_adapter])
    expect(result).to be_a(BabySMS::Receipt)

    # We should have one exception logged, and it should be bad_adapter
    expect(result.exceptions.size).to eq(1)
    expect(result.exceptions.first.adapter).to be(bad_adapter)
    expect(result.adapter).to be(good_adapter)
  end

  it 'records the successful adapter on success' do
    result = message.deliver(adapters: [good_adapter])
    expect(result).to be_instance_of(BabySMS::Receipt)

    expect(result.exceptions).to be_empty
    expect(result.adapter).to be(good_adapter)
  end
end
