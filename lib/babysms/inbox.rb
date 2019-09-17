module BabySMS
  class Inbox
    attr_reader :predicate
    attr_reader :handlers

    def initialize(predicate: nil, for_adapter: nil, for_number: nil, &block)
      if [predicate, for_adapter, for_number].compact.size > 1
        fail ArgumentError, "cant provide > 1 of [predicate:, for_adapter:, for_number:]"
      end

      @predicate = if predicate
        predicate
      elsif for_adapter
        for_adapter = BabySMS::Adapter.for_adapter_id(for_adapter) if for_adapter.is_a?(String)
        ->(adapter) { adapter == for_adapter }
      elsif for_number
        for_number = Phony.normalize(for_number)
        ->(adapter) { adapter.from == for_number}
      else
        ->(adapter) { true }
      end

      @handlers = {}
      DSLContext.new(self, &block)
    end

    def receive(message)
      call_handlers(:receive, message)
    end

    def relevant_for?(adapter)
      predicate.call(adapter)
    end

    def call_handlers(key, *args)
      Array(@handlers[key]).each do |handler|
        handler.call(*args)
      end
    end

    class DSLContext
      attr_reader :inbox

      def add_handler(key, handler)
        @inbox.handlers[key] ||= []
        @inbox.handlers[key].push(handler)
      end

      def initialize(inbox, &block)
        @inbox = inbox
        instance_eval(&block)
      end

      def receive(&block)
        add_handler(:receive, block)
      end
    end
  end
end
