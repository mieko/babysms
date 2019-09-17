require 'active_support'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/module/attribute_accessors'
require 'phony'

require 'babysms/version'
require 'babysms/adapter'
require 'babysms/receipt'
require 'babysms/errors'
require 'babysms/mail_man'
require 'babysms/message'

require 'babysms/adapters/test_adapter'
require 'babysms/adapters/bandwidth_adapter' if Object.const_defined?(:Bandwidth)
require 'babysms/adapters/nexmo_adapter' if Object.const_defined?(:Nexmo)
require 'babysms/adapters/plivo_adapter' if Object.const_defined?(:Plivo)
require 'babysms/adapters/twilio_adapter' if Object.const_defined?(:Twilio)

module BabySMS
  mattr_accessor :web_hook_root, default: "http://example.com/web_hooks/"
  mattr_accessor :strategy, default: :in_order
  mattr_accessor :adapters, default: [BabySMS::Adapters::TestAdapter.new(verbose: true)]

  # Shorthand to set a list of one adapter in the simple case
  def self.adapter=(adapter)
    self.adapters = [adapter]
  end

  def self.adapter
    fail "can't use #adapters= with multiple adapters" unless adapters.size == 1
    adapters.first
  end

  def self.available_adapters(test: false, cache: true)
    # Allow cache-busting
    @found_adapters = nil if !cache

    @found_adapters ||= begin
      BabySMS::Adapters.constants.map do |constant|
        cls = BabySMS::Adapters.const_get(constant)
        if cls.is_a?(Class) && cls.ancestors.include?(BabySMS::Adapter)
          cls
        end
      end.compact
    end

    if test
      @found_adapters
    else
      @found_adapters - [BabySMS::Adapters::TestAdapter]
    end
  end
end
