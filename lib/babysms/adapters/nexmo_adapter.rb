unless Object.const_defined?(:Nexmo)
  fail '`nexmo` gem is required to use NexmoAdapter'
end

module BabySMS
  module Adapters
    class NexmoAdapter
      attr_reader :client
      attr_reader :from

      def initialize(api_key:, api_secret:, from:)
        # Thanks for being weird.
        @from = from.sub(/\A\+/, '')

        @client = Nexmo::Client.new(api_key: api_key, api_secret: api_secret)
      end

      def deliver_now(message)
        response = client.sms.send(from: from,
                                   to: message.recipient,
                                   text: message.contents)
        if response.messages.first.status != '0'
          raise ::BabySMS::Message::FailedDelivery, response.messages.first.error_text
        end
      end
    end
  end
end
