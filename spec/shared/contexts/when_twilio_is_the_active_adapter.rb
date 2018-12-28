RSpec.shared_context 'when Twilio is the active adapter' do

  # `adapter` gets called by the parent wrapper when it does the setup
  subject(:adapter) { BabySMS::Adapters::TwilioAdapter.new }

  include_context 'wrap the adapter'

end

