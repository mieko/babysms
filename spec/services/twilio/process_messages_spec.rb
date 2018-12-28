require 'babysms/services/twilio/process_messages'

RSpec.describe BabySMS::Adapters::Twilio::ProcessMessages, type: :service do

  subject(:adapter) do
    BabySMS::Adapters::Twilio::ProcessMessages.
      new(
        account_sid: 'ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
        auth_token:  'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy'
      )
  end

  before(:each) do
    WebMock.
      stub_request(:any, 'twilio.com').
      to_return(status:  200,
                body:    '',
                headers: {})
  end

  # Magic numbers provided by Twilio for test API
  # https://www.twilio.com/docs/iam/test-credentials#test-incoming-phone-numbers-parameters-PhoneNumber
  let(:invalid_number) { "+15005550001" }
  let(:non_mobile_number) { "+15005550009" }
  let(:valid_number) { "+15005550006" }

  let(:invalid_message) do
    BabySMS::Message.new(recipient: invalid_number,
                         contents:  'Is this number still working?')
  end

  include_context 'setup data for adapter'
  include_examples 'send messages'

  it_should_behave_like BabySMS::Adapters

  #############################################################################
  describe 'with a valid message' do
    subject do
      BabySMS::Adapters::Twilio::ProcessMessages
    end

    it do
      should respond_to(:call)
    end
  end

  #############################################################################
  describe 'with an invalid message' do
    subject do
      BabySMS::Adapters::Twilio::ProcessMessages.call(messages:    [invalid_message],
                                                      account_sid: 'ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
                                                      auth_token:  'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy')
    end
    it { should eq true }
  end

  #############################################################################
  describe 'with an invalid message' do
    subject do
      BabySMS::Adapters::Twilio::ProcessMessages.call(messages:    [],
                                                      account_sid: 'ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
                                                      auth_token:  'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy')
    end

    before do
      stub_request(:post, 'https://api.twilio.com/2010-04-01/Accounts/1234/Messages.json').
        with(body: { To: invalid_number }).
        to_return(
          error: BabySMS::Adapters::Twilio.
            RESPONSE_CODES[:invalid]
        )
    end

    it { should raise_error }
  end


  #############################################################################
  it "does not attempt to deliver to invalid recipients" do

    BabySMS.adapter = BabySMS::Adapters::Twilio
    ProcessMessages.call(messages)
    adapter
    messages
    client
    )
    BabySMS.adapter = subject


    # Make the message invalid
    allow(invalid_message).to receive(:valid?).and_return(false)
    expect(subject.call).to eq false

    # stub_request(:post, 'https://api.twilio.com/2010-04-01/Accounts/1234/Messages.json')
    #   .with(body: {
    #     Body: invalid_message.contents,
    #     To:   invalid_message.recipient
    #   })
    #   .to_return(error:)

    expect(subject.errors).to include(:message)
  end
end

end
