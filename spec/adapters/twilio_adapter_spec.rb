# frozen_string_literal: true

require 'rainbow'
require 'babysms/adapters/twilio_adapter'
require 'babysms/message'
require 'twilio-ruby'
require 'webmock/rspec'
require 'shoulda-matchers'
require 'shoulda/matchers/active_model'
require 'active_model'
require 'active_model/validations'

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

  it { is_expected.to have_attributes(verbose: false) }
  it { is_expected.to validate_presence_of(:account_sid) }
  it { is_expected.to validate_presence_of(:auth_token) }

  it 'does not print outgoing SMS messages to the terminal by default' do
    expect { subject.deliver_now(message) }.not_to output.to_stdout
  end

  context 'when .verbose is true' do
    subject do
      adapter.then do |s|
        s.verbose = true
        s
      end
    end

    it 'prints outgoing SMS messages to the terminal' do
      expect { subject.deliver_now(message) }.to output.to_stdout
    end
  end

  it 'saves outgoing messages in the outbox' do
    expect(subject.outbox).to be_empty
    expect(subject.deliver_now(message)).to eq true
    expect(subject.outbox.size).to eq(1)
    expect(subject.outbox.first).to eq(message)
  end
end
