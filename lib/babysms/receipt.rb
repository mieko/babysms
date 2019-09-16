module BabySMS
  class Receipt
    attr_reader :message
    attr_reader :adapter
    attr_reader :exceptions
    attr_reader :delivery_id

    def initialize(message:, adapter:, exceptions:, delivery_id:)
      @message = message
      @adapter = adapter
      @exceptions = exceptions
      @delivery_id = delivery_id
    end

    def token
      "#{adapter.id}:#{delivery_id}"
    end

    def exceptions?
      ! exceptions.empty?
    end
  end
end
