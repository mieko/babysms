module BabySMS
  class Error < StandardError
  end

  # A FailedDelivery being raised means your message didn't get sent.  This can be because of a
  # single error, or multiple failed attempts.
  #
  # A FailedDelivery may contain multiple "sub-exceptions" in #exception that can be inspected
  # to determine what happened.
  class FailedDelivery < BabySMS::Error
    attr_reader :exceptions
    attr_reader :adapter

    def initialize(*args, adapter: nil)
      super(*args)

      @adapter = adapter
      @exceptions = [self]
    end

    def self.multiple(exceptions)
      # We don't want to give a public interface to setting exceptions
      BabySMS::FailedDelivery.new("multiple exceptions").itself do |result|
        result.instance_variable_set(:@exceptions, exceptions)
      end
    end

    def multiple?
      exceptions.size > 1
    end
  end

  class WebHookError < BabySMS::Error
  end

  # Post from provider we don't understand
  class Malformed < BabySMS::WebHookError
  end

  # Provider signature verification fails
  class Unauthorized < BabySMS::WebHookError
  end
end
