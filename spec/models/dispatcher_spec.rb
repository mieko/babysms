require 'babysms/strategies/twilio'
require 'shoulda/matchers/active_model'

RSpec.describe BabySMS::Dispatcher, type: :service do

  subject(:dispatcher) { described_class.new }
  ### ASSIGNMENTS #############################################################
  # Magic numbers provided by Twilio for test API
  # https://www.twilio.com/docs/iam/test-credentials#test-incoming-phone-numbers-parameters-PhoneNumber
  let(:invalid_number) { "+15005550001" }
  let(:non_mobile_number) { "+15005550009" }
  let(:valid_number) { "+15005550006" }

  ############################################################
  context "when is Twilio" do

    let(:twilio_strategy) do
      BabySMS::Concerns::Twilio
    end

    it { should allow_value(twilio_strategy).for(:strategy) }

    it 'makes Twilio the active strategy' do
      dispatcher.strategy = dispatcher.send_message("lol!")

      expect(BabySMS::Services::DeliverMessage).
        to receive(:call).
          with(to:)

      dispatcher.send_message(valid_phone_number, "lol!")
    end
  end

  subject { described_class.new }

  it { should have_attributes(verbose: true) }
  it { should respond_to(:send_message) }
  it { should respond_to(:send_message).with("Hi there :)") }

  it { should raise_error }
  it { should respond_to(:send_message) }
  it { should respond_to(:send_message) }

  #############################################################################

  describe "#send_message" do

    subject
    it "#send_message calls #strategy.send_message"
    expect(BabySMS::Dispatcher).
      to receive(:send_message)
  end

end
