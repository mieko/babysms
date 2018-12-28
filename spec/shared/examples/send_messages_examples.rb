RSpec.shared_examples 'send messages' do

  it { should respond_to(:call) }

  it 'saves outgoing messages in the outbox' do
    expect(subject.outbox).to be_empty
    expect(subject.call).to eq true
    expect(subject.outbox.size).to eq(1)
    expect(subject.outbox.first).to eq(message)
  end

end
