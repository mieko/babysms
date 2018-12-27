require 'babysms/adapters/twilio_adapter'

RSpec.describe BabySMS::Adapters::TwilioAdapter, type: :model do

  subject(:adapter) do
    BabySMS::Adapters::TwilioAdapter
      .new(
        account_sid: '1234',
        auth_token:  '5678'
      )
  end

  it_behaves_like BabySMS::Adapters

  before(:each) do
    WebMock.stub_request(:any, 'twilio.com')

    stub_request(:post, 'https://api.twilio.com/2010-04-01/Accounts/1234/Messages.json')
      .to_return(status:  200,
                 body:    '',
                 headers: {})
  end

  # Magic numbers provided by Twilio for test API
  # https://www.twilio.com/docs/iam/test-credentials#test-incoming-phone-numbers-parameters-PhoneNumber
  let(:invalid_number) { "+15005550001" }
  let(:non_mobile_number) { "+15005550009" }
  let(:valid_number) { "+15005550006" }

  it { is_expected.to validate_presence_of(:account_sid) }
  it { is_expected.to validate_presence_of(:auth_token) }

  let(:invalid_message) do
    BabySMS::Message.new(recipient: invalid_number,
                         contents:  'Is this number still working?')
  end

  it "does not attempt to deliver to invalid recipients" do

    # Make deliver_now(invalid_message) return a response of 404
    stub_request(:post, 'https://api.twilio.com/2010-04-01/Accounts/1234/Messages.json')
      .with(body: {
        Body: invalid_message.contents,
        To:   invalid_message.recipient
      })
      .to_return(status:  200,
                 body:    '',
                 headers: {})


    expect { invalid_message }.to raise_error(ActiveModel::ValidationError)
  end

end
