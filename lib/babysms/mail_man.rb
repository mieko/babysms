module BabySMS

  # MailMan is the link between a Message and an Adapter.  It basically has a strategy for
  # choosing adapters, and attempting delivery until either the message is delivered, or
  # all adapters have been tried.
  #
  # The boring strategy is :in_order, which is good for cases where you have a primary
  # adapter, and one or more fallbacks.
  #
  # The alternative is :random, which sort of works in a load-balancing kind of way.

  class MailMan
    attr_reader :adapters
    attr_reader :strategy

    def initialize(adapters:, strategy:)
      unless respond_to?(:"next_#{strategy}_adapter")
        fail ArgumentError, "invalid strategy: #{strategy}"
      end

      @adapters = adapters.dup
      @strategy = strategy
    end

    def next_in_order_adapter
      adapters.shift
    end

    def next_random_adapter
      adapters.delete(adapters.sample)
    end

    def next_adapter
      send(:"next_#{strategy}_adapter")
    end

    # returns each adapter in the order specified by the strategy.  Mutates adapters Array.
    def each_adapter(&block)
      loop do
        raise StopIteration if adapters.empty?
        yield next_adapter
      end
    end

    def deliver(message)
      if @adapters.empty?
        raise BabySMS::Error, 'no adapter configured'
      end

      # We collect and return all errors leading up to the (hopefully) successful delivery
      failures = []
      each_adapter do |adapter|
        return BabySMS::Receipt.new(message_uuid: adapter.deliver(self),
                                    message: message,
                                    adapter: adapter,
                                    exceptions: failures)
      rescue BabySMS::FailedDelivery => e
        failures.push(e)
      end

      raise BabySMS::FailedDelivery.multiple(failures)
    end
  end
end
