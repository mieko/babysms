require "active_support"

require "babysms/version"
require "babysms/message"

require "babysms/adapters/test_adapter"
require "babysms/adapters/twilio_adapter" if Object.const_defined?(:Twilio)
require "babysms/adapters/nexmo_adapter" if Object.const_defined?(:Nexmo)
require "babysms/adapters/bandwidth_adapter" if Object.const_defined?(:Bandwidth)
require "babysms/adapters/plivo_adapter" if Object.const_defined?(:Plivo)

module BabySMS
  mattr_accessor :adapters, default: []

  def self.adapter=(adapter)
    self.adapters = [adapter]
  end

  def self.adapter
    adapters.first
  end

  self.adapter = BabySMS::Adapters::TestAdapter.new(verbose: true)
end
