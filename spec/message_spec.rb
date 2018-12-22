require 'babysms/message'

RSpec.describe BabySMS::Message do
  subject(:message) do
    BabySMS::Message.new(recipient: '+1 555-555-5555', contents: 'Hello, world')
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
end
