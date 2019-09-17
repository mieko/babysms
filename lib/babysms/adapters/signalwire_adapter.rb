unless Object.const_defined?(:Signalwire)
  fail '`signalwire-ruby` gem is required to use SignalwireAdapter'
end

require 'signalwire/sdk'

module BabySMS
  module Adapters
    class SignalwireAdapter < BabySMS::Adapter
      def initialize(from:, project:, token:, space_url:)
        super(from: from)
        self.client = Signalwire::REST::Client.new(project, token, signalwire_space_url: space_url)
      end

      def deliver(message)
        result = client.messages.create(from: from,
                                        to: message.to,
                                        body: message.contents,
                                        status_callback: web_hook.end_point)
        result.sid
      rescue Signalwire::REST::SignalwireError => e
        raise BabySMS::FailedDelivery.new(e.message, adapter: self)
      end

      class WebHook < BabySMS::WebHook
        def process(app:, report:)
          # Of note: NumMedia, and MediaContentType0, MediaUrl0
          message = BabySMS::Message.new(from: app.params['from'],
                                         to: app.params['to'],
                                         contents: app.params['body'],
                                         uuid: app.params['id'])
          report.incoming_message(message)
          [200, { 'Content-Type' => 'application/xml' }, '<Response></Response>']
        end
      end
    end
  end
end
