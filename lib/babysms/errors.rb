module BabySMS
  class Error < StandardError
  end

  # This isn't an exception in its truest sense: it's never thrown, but returned.
  # However, it holds exceptions encountered along the way that were overcome.
  #
  # The adapter that actually delivered the message is stored in #adapter
  class SuccessfulDelivery
    attr_reader :message
    attr_reader :adapter
    attr_reader :exceptions

    def initialize(message, adapter:, exceptions:)
      @message = message
      @adapter = adapter
      @exceptions = exceptions
    end

    def exceptions?
      ! exceptions.empty?
    end
  end

  # A FailedDelivery being raised means your message didn't get sent.  This can be because of a
  # single error, or multiple failed attempts via multiple adapters.
  #
  # A FailedDelivery can contain multiple "sub-exceptions" in #exception that can be inspected
  # to determine what happened
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
      FailedDelivery.new("multiple exceptions").itself do |result|
        result.instance_variable_set(:@exceptions, exceptions)
      end
    end

    def multiple?
      exceptions.size > 1
    end
  end
end
