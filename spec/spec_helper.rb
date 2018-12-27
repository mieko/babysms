require "bundler/setup"
require "babysms"

###############################################################################
require "shoulda-matchers"
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :active_model
  end
end

RSpec.configure do |config|
  config.include(Shoulda::Matchers::ActiveModel, type: :model)
end

### Loads all RSpec shared examples and shared contexts
# spec/shared/contexts/*.rb
# spec/shared/examples/*.rb
Dir[File.join(__dir__, 'shared', 'contexts', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'shared', 'examples', '*.rb')].each { |file| require file }
