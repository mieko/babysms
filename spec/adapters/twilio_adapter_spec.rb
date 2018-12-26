require 'babysms/adapters/twilio_adapter'
require 'babysms/message'

RSpec.describe BabySMS::Adapters::TwilioAdapter do
  let(:message) do
    BabySMS::Message.new(recipient: '+1 555-555-5555', contents: 'Hello, World.')
  end

  subject(:adapter) do
    BabySMS::Adapters::TwilioAdapter.new
  end

  around(:each) do |example|
    saved           = BabySMS
    BabySMS.adapter = subject
    example.run
    BabySMS.adapter = saved
  end

  it { is_expected.to have_attributes(verbose: false) }

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
    subject.deliver_now(message)
    expect(subject.outbox.size).to eq(1)
    expect(subject.outbox.first).to eq(message)
  end
end
