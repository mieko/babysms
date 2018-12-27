RSpec.shared_examples BabySMS::Message do
  include_context 'message'

  it "calls #deliver_now on the currently active adapter" do
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
