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
        def validate!(request)
          validator = Twilio::Security::RequestValidator.new(adapter.client.auth_token)
          unless validator.validate(end_point, request.params,
                                    request.headers['X-Twilio-Signature'])
            fail BabySMS::Unauthorized, 'twilio signature failed'
          end
        end

        def process(app:, report:)
          validate!(app.request)

          # Of note: NumMedia, and MediaContentType0, MediaUrl0
          message = BabySMS::Message.new(from: app.params['From'],
                                         to: app.params['To'],
                                         contents: app.params['Body'],
                                         uuid: app.params['MessageSid'])
          report.incoming_message(message)
          [200, { 'Content-Type' => 'application/xml' }, '<Response></Response>']
        end
      end
    end
  end
end
