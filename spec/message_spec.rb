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

  it "calls deliver_now on the configured adapter" do
    expect(BabySMS.adapter).to receive(:deliver_now)
    message.deliver_now
  end

  it "does not attempt to deliver to invalid recipients" do
    message.recipient = '5'
    expect do
      message.deliver_now
    end.to raise_error(ActiveModel::ValidationError)
  end

  it "attempts all adapters until success" do
    expect(good_adapter).to receive(:deliver_now)

    message.deliver_now(adapters: [bad_adapter, good_adapter])
  end

  it "raises an error if all adapters fail" do
    expect do
      message.deliver_now(adapters: [bad_adapter])
    end.to raise_error(BabySMS::Message::FailedDelivery)
  end

  it "doesn't raise an error if one adapter succeeds" do
    expect do
      message.deliver_now(adapters: [bad_adapter, good_adapter])
    end.not_to raise_error
  end

  it "collects earlier adapter errors on successful delivery" do
    result = message.deliver_now(adapters: [bad_adapter, good_adapter])
    expect(result.size).to equal(1)
  end
end
