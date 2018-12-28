require 'babysms/adapters/twilio_adapter'

RSpec.describe BabySMS::Adapters::TwilioAdapter, type: :model do

  it do
    should respond_to(:new).with(account_sid: '1234',
                                 auth_token:  '5678')
  end
end
