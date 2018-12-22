require "babysms/version"
require "babysms/adapters/test_adapter"
require "active_support"

module BabySMS
  mattr_accessor :adapter
  self.adapter = BabySMS::Adapters::TestAdapter.new(verbose: true)
end
