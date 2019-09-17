unless Object.const_defined?(:Twilio)
  fail '`twilio-ruby` gem is required to use TwilioAdapter'
end

module BabySMS
  module Adapters
    class TwilioAdapter < BabySMS::Adapter
      def initialize(account_sid:, auth_token:, from:)
        super(from: from)

        self.client = Twilio::REST::Client.new(account_sid, auth_token)
      end

      def deliver(message)
        result = client.api.account.messages.create(from: from,
                                                    to: message.to,
                                                    body: message.contents,
                                                    status_callback: web_hook.end_point)
        result.sid
      rescue Twilio::REST::TwilioError => e
        raise BabySMS::FailedDelivery.new(e.message, adapter: self)
      end

      class WebHook < BabySMS::WebHook
        def process(request, response)
          "<Response></Response>"
        end
      end
    end
  end
end
