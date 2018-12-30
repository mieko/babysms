unless Object.const_defined?(:Bandwidth)
  fail '`ruby-bandwidth` gem is required to use BandwidthAdapter'
end

module BabySMS
  module Adapters
    class BandwidthAdapter
      attr_reader :client
      attr_reader :from

      def initialize(user_id:, api_token:, api_secret:, from:)
        @from = from
        @client = Bandwidth::Client.new(user_id: user_id,
                                        api_token: api_token,
                                        api_secret: api_secret)
      end

      def deliver_now(message)
        response = Bandwidth::Message.create(client,
                                             from: from,
                                             to: message.recipient,
                                             text: message.contents)
         if response[:error]
           raise ::BabySMS::Message::FailedDelivery, response[:error].to_s
         end
      end
    end
  end
end
