unless Object.const_defined?(:Twilio)
  fail '`twilio-ruby` gem is required to use TwilioAdapter'
end

module BabySMS
  module Adapters
    class TwilioAdapter
      attr_reader :client
      attr_reader :from

      def initialize(account_sid:, auth_token:, from:)
        @from = from
        @client = Twilio::REST::Client.new(account_sid, auth_token)
      end

      def deliver_now(message)
        client.api.account.messages.create(from: from,
                                           to: message.recipient,
                                           body: message.contents)
      rescue Twilio::REST::TwilioError => e
        raise ::BabySMS::Message::FailedDelivery, e.message
      end
    end
  end
end
