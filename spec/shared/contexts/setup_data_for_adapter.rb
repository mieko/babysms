RSpec.shared_context 'setup data for adapter' do

  # Backup the current before and after the example
  around(:each) do |example|
    saved           = BabySMS
    BabySMS.adapter = subject
    example.run
    BabySMS.adapter = saved
  end

  let(:message) do
    BabySMS::Message.new(recipient: valid_number,
                         contents:  'Hey whats up?')
  end

  let(:invalid_message) do
    BabySMS::Message.new(recipient: invalid_number,
                         contents:  'Is this number still working?')
  end

  let(:non_mobile_message) do
    BabySMS::Message.new(recipient: non_mobile_number,
                         contents:  'Texting your home phone')
  end

end

RSpec.shared_examples BabySMS::Adapters do

end
