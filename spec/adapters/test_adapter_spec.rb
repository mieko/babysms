require 'babysms/adapters/test_adapter'
require 'babysms/message'
require 'babysms/report'
require 'babysms/web_application'
require_relative 'contexts/as_a_web_hook'

RSpec.describe BabySMS::Adapters::TestAdapter do
  subject(:adapter) do
    BabySMS::Adapters::TestAdapter.new
  end

  let(:message) do
    BabySMS::Message.new(to: '+1 555-555-5555', contents: 'Hello, World.')
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
    expect { subject.deliver(message) }.to output.to_stderr
  end

  it 'does not print outgoing SMS messages to the terminal if verbose is false' do
    subject.verbose = false
    expect { subject.deliver(message) }.not_to output.to_stderr
  end

  it 'saves outgoing messages in the outbox' do
    expect(subject.outbox).to be_empty
    subject.deliver(message)
    expect(subject.outbox.size).to eq(1)
    expect(subject.outbox.first).to eq(message)
  end

  describe BabySMS::Adapters::TestAdapter::WebHook do
    include Rack::Test::Methods
    include_context 'as a WebHook'

    def app
      ::BabySMS::WebApplication
    end

    let(:web_hook) do
      subject.web_hook
    end

    it 'supports web hooks' do
      expect(subject.web_hook?).to be_truthy
      expect(subject.web_hook).to be_a(BabySMS::WebHook)
    end

    it "can receive a message" do
      request_data = load_example("incoming_message")
      post(web_hook.mount_point, request_data, { 'CONTENT_TYPE' => 'application/json' })

      expect(last_response).to be_ok
      expect(last_response.body).to eq('ok')
    end
  end
end
