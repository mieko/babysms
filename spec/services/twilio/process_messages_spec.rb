require 'babysms/services/twilio/process_messages'
require 'babysms/adapters/twilio_adapter'

RSpec.describe BabySMS::Services::Twilio::ProcessMessages, type: :service do

  before(:each) do
    WebMock.
      stub_request(:any, 'twilio.com').
      to_return(status:  200,
                body:    '',
                headers: {})

    WebMock.
      stub_request(:any, 'twilio.com').
      with(body: { To: invalid_number }).
      to_return(status:  200,
                body:    BabySMS::Strings::Twilio::ResponseCodes::INVALID,
                headers: {})
  end

  # Magic numbers provided by Twilio for test API
  # https://www.twilio.com/docs/iam/test-credentials#test-incoming-phone-numbers-parameters-PhoneNumber
  let(:invalid_number) { "+15005550001" }
  let(:non_mobile_number) { "+15005550009" }
  let(:valid_number) { "+15005550006" }

  include_context 'when Twilio is the active adapter'

  it 'can create and send an SMS' do
    subject.call(messages: [message])
  end

  #############################################################################
  describe 'with a valid message' do
    let(:message) do
      BabySMS::Message.new(recipient: invalid_number,
                           contents:  'Is this number still working?')
    end

    it { should respond_to(:call) }

  end

end
