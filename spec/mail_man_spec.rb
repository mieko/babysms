RSpec.describe(BabySMS::MailMan) do
  let(:message) do
    BabySMS::Message.new(recipient: '+1 (555) 867-5309', contents: 'Hello, world')
  end

  it 'attempts deliveries to adapters in-order with :in_order strategy' do
    adapter_chain = [
      BabySMS::Adapters::TestAdapter.new(from: '+15550001111', fails: true),
      BabySMS::Adapters::TestAdapter.new(from: '+15552223333', fails: true),
      BabySMS::Adapters::TestAdapter.new(from: '+15554445555', fails: false),
    ]

    expect(adapter_chain[0]).to receive(:deliver).ordered.once.and_call_original
    expect(adapter_chain[1]).to receive(:deliver).ordered.once.and_call_original
    expect(adapter_chain[2]).to receive(:deliver).ordered.once.and_call_original

    mail_man = BabySMS::MailMan.new(adapters: adapter_chain, strategy: :in_order)

    result = mail_man.deliver(message)
    expect(result).to be_a(BabySMS::Receipt)

    # Did we log errors correctly?
    expect(result.exceptions).to be_an(Array)
    expect(result.exceptions.map(&:adapter)).to eq(adapter_chain.first(2))

    # And log the adapter that actually worked?
    expect(result.adapter).to be(adapter_chain.last)
  end

  it 'attempts deliveries to adapters in-order with :in_order strategy' do
    adapter_chain = [
      BabySMS::Adapters::TestAdapter.new(from: '+15550001111', fails: true),
      BabySMS::Adapters::TestAdapter.new(from: '+15552223333', fails: true),
      BabySMS::Adapters::TestAdapter.new(from: '+15554445555', fails: false),
    ]

    mail_man = BabySMS::MailMan.new(adapters: adapter_chain, strategy: :random)
    expect(mail_man).to receive(:next_random_adapter).at_least(:once).and_call_original

    result = mail_man.deliver(message)
    expect(result).to be_a(BabySMS::Receipt)
  end

  it 'raises FailedDelivery on failure' do
    adapter_chain = [
      BabySMS::Adapters::TestAdapter.new(from: '+15550001111', fails: true),
      BabySMS::Adapters::TestAdapter.new(from: '+15552223333', fails: true)
    ]
    mail_man = BabySMS::MailMan.new(adapters: adapter_chain, strategy: :in_order)

    expect { mail_man.deliver(message) }.to raise_error(BabySMS::FailedDelivery)
  end
end
