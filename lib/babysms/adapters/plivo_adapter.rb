unless Object.const_defined?(:Plivo)
  fail '`plivo-ruby` gem is required to use PlivoAdapter'
end

module BabySMS
  module Adapters
    class PlivoAdapter
      attr_reader :client
      attr_reader :from

      def initialize(auth_id:, auth_token:, from:)
        @from = from
        @client = Plivo::RestClient.new(auth_id, auth_token)
      end

      def deliver_now(message)
        client.messages.create(from, [message.recipient], message.contents)
      rescue PlivoRESTError => e
        raise ::BabySMS::Message::FailedDelivery, e.message
      end
    end
  end
end
