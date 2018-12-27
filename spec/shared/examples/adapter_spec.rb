RSpec.shared_examples BabySMS::Adapters do

  include_context BabySMS::Message

  it { is_expected.to have_attributes(verbose: false) }

  around(:each) do |example|
    saved           = BabySMS
    BabySMS.adapter = subject
    example.run
    BabySMS.adapter = saved
  end

  it "calls #deliver_now on the currently active adapter" do
    expect(BabySMS.adapter).to receive(:deliver_now)
    message.deliver_now
  end

  it "does not attempt to deliver to invalid recipients" do
    message.recipient = '5'
    expect { message.deliver_now }.to raise_error(ActiveModel::ValidationError)
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
