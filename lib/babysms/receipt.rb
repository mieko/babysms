module BabySMS
  class Receipt
    attr_reader :message
    attr_reader :adapter
    attr_reader :exceptions
    attr_reader :message_uuid

    def initialize(message:, adapter:, exceptions:, message_uuid:)
      @message = message
      @adapter = adapter
      @exceptions = exceptions
      @message_uuid = message_uuid
    end

    def token
      "#{adapter.id}:#{message_uuid}"
    end

    def exceptions?
      !exceptions.empty?
    end
  end
end
