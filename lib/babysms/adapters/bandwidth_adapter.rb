unless Object.const_defined?(:Bandwidth)
  fail '`ruby-bandwidth` gem is required to use BandwidthAdapter'
end

module BabySMS
  module Adapters
    class BandwidthAdapter < BabySMS::Adapter
      def initialize(user_id:, api_token:, api_secret:, from:)
        super(from: from)

        self.client = Bandwidth::Client.new(user_id: user_id,
                                            api_token: api_token,
                                            api_secret: api_secret)
      end

      def deliver(message)
        response = Bandwidth::Message.create(client,
                                             from: from,
                                             to: message.recipient,
                                             text: message.contents)
        if response[:error]
          raise BabySMS::FailedDelivery.new(response[:error].to_s, adapter: self)
        end

        return response[:id]
      end
    end
  end
end
