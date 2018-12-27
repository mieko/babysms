RSpec.shared_examples BabySMS::Adapters do

  include_context BabySMS::Message

  around(:each) do |example|
    saved           = BabySMS
    BabySMS.adapter = subject
    example.run
    BabySMS.adapter = saved
  end

  it "calls #deliver_now on the currently active adapter" do
    expect(BabySMS.adapter).to receive(:deliver_now)
    message.deliver_now
  end

  it "does not attempt to deliver to invalid recipients" do
    message.recipient = '5'
    expect { message.deliver_now }.to raise_error(ActiveModel::ValidationError)
  end
end
