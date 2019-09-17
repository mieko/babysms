unless Object.const_defined?(:Nexmo)
  fail '`nexmo` gem is required to use NexmoAdapter'
end

module BabySMS
  module Adapters
    class NexmoAdapter < BabySMS::Adapter
      def initialize(api_key:, api_secret:, from:)
        super(from: from)

        self.client = Nexmo::Client.new(api_key: api_key, api_secret: api_secret)
      end

      def deliver(message)
        # Thanks for being weird, Nexmo.  Rejects numbers starting with "+"
        response = client.sms.send(from: from.gsub(/\A\+/, ''),
                                   to: message.to,
                                   text: message.contents)
        if response.messages.first.status != '0'
          raise BabySMS::FailedDelivery.new(response.messages.first.error_text,
                                            adapter: self)
        end

        response.messages.first.message_id
      end

      class WebHook < BabySMS::WebHook
        def process(app:, report:)
          fail BabySMS::WebHookError
        end
      end
    end
  end
end
