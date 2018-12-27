require "bundler/setup"
require "babysms"
require "shoulda-matchers"
require "shoulda/matchers/active_model"
require "shoulda/matchers/active_record"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

### Loads all RSpec shared examples and shared contexts
# spec/shared/contexts/*.rb
# spec/shared/examples/*.rb
Dir[File.join(__dir__, 'shared', 'contexts', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'shared', 'examples', '*.rb')].each { |file| require file }

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :active_record
    with.library :active_model
  end
end
