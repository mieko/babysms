require 'twilio-ruby'

RSpec.describe 'Create and send an SMS', type: :feature do

  let(:adapter) { BabySMS::Adapters::Twilio }

  # To avoid interfering with other adapter's specs
  around(:each) do |block|
    saved           = BabySMS.adapter
    BabySMS.adapter = adapter
    block.call
    BabySMS.adapter = saved
  end

  it 'can create and send an SMS' do
    subject.call(messages: [message])
  end

end
