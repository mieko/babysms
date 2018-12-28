require 'shoulda/matchers/active_model'

RSpec.shared_examples BabySMS::Concerns::ServiceObject do

  it { should respond_to(:call) }

end
