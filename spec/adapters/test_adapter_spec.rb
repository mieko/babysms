require 'babysms/adapters/test_adapter'
require 'babysms/message'

RSpec.describe BabySMS::Adapters::TestAdapter do
  let(:message) do
    BabySMS::Message.new(recipient: '+1 555-555-5555', contents: 'Hello, World.')
  end

  subject(:adapter) do
    BabySMS::Adapters::TestAdapter.new
  end

  around(:each) do |block|
    saved = BabySMS.adapter
    BabySMS.adapter = subject
    begin
      block.call
    ensure
      BabySMS.adapter = saved
    end
  end

  it 'has an adapter_name of "test"' do
    expect(BabySMS::Adapters::TestAdapter.adapter_name).to eq("test")
  end

  it 'generates sequential ids' do
    result = subject.deliver(message)
    expect(result).to eq '1'

    result = subject.deliver(message)
    expect(result).to eq '2'
  end

  it 'has an id generated from its "from" number' do
    expect(subject.adapter_id).to eq('15555555555@test')

    another_adapter = BabySMS::Adapters::TestAdapter.new(from: '+15558675309')
    expect(another_adapter.adapter_id).to eq('15558675309@test')
  end

  it 'is not verbose by default' do
    expect(subject.verbose).to be_falsy
  end

  it 'prints outgoing SMS messages to the terminal if verbose is true' do
    subject.verbose = true
    expect do
      subject.deliver(message)
    end.to output.to_stderr
  end

  it 'does not print outgoing SMS messages to the terminal if verbose is false' do
    subject.verbose = false
    expect do
      subject.deliver(message)
    end.not_to output.to_stderr
  end

  it 'saves outgoing messages in the outbox' do
    expect(subject.outbox).to be_empty
    subject.deliver(message)
    expect(subject.outbox.size).to eq(1)
    expect(subject.outbox.first).to eq(message)
  end
end
