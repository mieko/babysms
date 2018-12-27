error_codes = {
  '21212': "This phone number is invalid.",
  '21606': "This phone number is not owned by your account or is not SMS-capable.",
  '21611': "This number has an SMS message queue that is full.",
  '21606': "This phone number is not owned by your account or is not SMS-capable."
}.freeze

RSpec.shared_context BabySMS::Adapters do

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

  it { is_expected.to have_attributes(verbose: false) }

  it "calls #deliver_now on the currently active adapter" do
    expect(BabySMS.adapter).to receive(:deliver_now)
    message.deliver_now
  end

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
