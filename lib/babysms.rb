require "active_support"

require "babysms/version"
require "babysms/message"
require "babysms/adapters/test_adapter"

module BabySMS
  mattr_accessor :adapter
  self.adapter = BabySMS::Adapters::TestAdapter.new(verbose: true)
end
