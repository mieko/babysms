require 'twilio-ruby'

module BabySMS
  module Services
    module Twilio
      class ProcessMessages < BaseService

        def initialize(**args)
          super

          @messages = args[:messages]
        end

        def call
          @messages.each do |m|
            BabySMS::Adapters::Twilio::DeliverSMS.call(
              to:   m.recipient,
              from: m.sender,
              body: m.contents
            )
          end
        end

      end
    end
  end
end
