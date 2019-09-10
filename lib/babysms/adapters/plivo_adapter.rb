unless Object.const_defined?(:Plivo)
  fail '`plivo-ruby` gem is required to use PlivoAdapter'
end

module BabySMS
  module Adapters
    class PlivoAdapter < BabySMS::Adapter
      def initialize(auth_id:, auth_token:, from:)
        super(from: from)

        self.client = Plivo::RestClient.new(auth_id, auth_token)
      end

      def deliver(message)
        client.messages.create(from, [message.recipient], message.contents)
      rescue PlivoRESTError => e
        raise BabySMS::FailedDelivery.new(e.message, adapter: self)
      end
    end
  end
end
