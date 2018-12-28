require "bundler/setup"
require "babysms"
require 'webmock/rspec'

###############################################################################
### Shoulda::Matchers
require 'shoulda/matchers'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# spec/shared/contexts/*.rb
# spec/shared/examples/*.rb
Dir[File.join(__dir__, 'shared', 'contexts', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'shared', 'examples', '*.rb')].each { |file| require file }

RSpec.configuration do |c|
  c.alias_it_behaves_like_to :it_behaves_like_a, 'it behaves like a:'
end
