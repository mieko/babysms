require 'babysms/adapters/twilio_adapter'

RSpec.describe BabySMS::Adapters::TwilioAdapter, type: :model do
  subject(:adapter) do
    BabySMS::Adapters::TwilioAdapter
      .new(
        account_sid: '1234',
        auth_token:  '1234'
      )
  end

  before(:each) do
    WebMock.stub_request(:any, 'twilio.com')

    stub_request(:post, 'https://api.twilio.com/2010-04-01/Accounts/1234/Messages.json')
      .with(body: {
        Body: 'Hey whats up',
        To:   '+1 555-555-5555'
      })
      .to_return(status:  200,
                 body:    '',
                 headers: {})
  end

  it_behaves_like BabySMS::Adapters
  include_context BabySMS::Message

  it { is_expected.to validate_presence_of(:account_sid) }
  it { is_expected.to validate_presence_of(:auth_token) }
end
