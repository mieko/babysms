require 'babysms/adapters/twilio_adapter'
require 'babysms/message'
require 'twilio-ruby'
require 'webmock/rspec'
require 'shoulda-matchers'

RSpec.describe BabySMS::Adapters::TwilioAdapter do

  include Shoulda::Matchers

  # Stub out requests for twilio API
  before(:each) do
    WebMock.stub_request(:any, "twilio.com")
    WebMock.stub_request(:any, "api.twilio.com")
  end

  include_context 'message'
  it_behaves_like BabySMS::Message

  around(:each) do |example|
    saved           = BabySMS
    BabySMS.adapter = subject
    example.run
    BabySMS.adapter = saved
  end

  it { is_expected.to have_attributes(verbose: false) }
  it { is_expected.to validate_presence_of(:account_sid) }
  it { is_expected.to validate_presence_of(:auth_token) }

  #   end
  #
  #   # set up a client to talk to the Twilio REST API
  #   @client = Twilio::REST::Client.new (account_sid, auth_token)
  #
  #   outbox.push(message)

  it "prints outgoing SMS messages to the terminal if verbose is true" do
    subject.verbose = true
    expect do
      subject.deliver_now(message)
    end.to output.to_stdout
  end

  it "does not print outgoing SMS messages to the terminal if verbose is false" do
    subject.verbose = false
    expect do
      subject.deliver_now(message)
    end.not_to output.to_stdout
  end

  it "saves outgoing messages in the outbox" do
    expect(subject.outbox).to be_empty
    expect(subject.deliver_now(message)).to eq true
    expect(subject.outbox.size).to eq(1)
    expect(subject.outbox.first).to eq(message)
  end
end
