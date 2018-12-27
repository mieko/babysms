RSpec.shared_context 'message' do

  let(:message) do
    BabySMS::Message.new(
      recipient: '+1 555-555-5555',
      contents:  'Hey whats up'
    )
  end

end
