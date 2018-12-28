require 'twilio-ruby'
require_relative 'base_adapter'

module BabySMS
  module Strings
    module Twilio
      module ResponseCodes
        SUCCESS       = ''
        INVALID       = '21212'
        NON_MOBILE    = '21606'
        MESSAGES_FULL = '21611'
      end

      module ResponseMessages
        INVALID = "This phone number is invalid.",
          NON_MOBILE = "This phone number is not owned by your account or is not SMS-capable.",
          MESSAGES_FULL = "This number has an SMS message queue that is full."
      end
    end
  end
end

module BabySMS
  module Adapters

    using BabySMS::Strings::Twilio
    class TwilioAdapter < BaseAdapter

      def initialize(**args)
        super

        @account_sid = args[:account_sid]
        @auth_token  = args[:auth_token]
        @client      = Twilio::REST::Client.new(@account_sid,
                                                @auth_token)
      end

      def deliver(message)
        response_code =
          @client.api.account.messages.create(
            to:   message.recipient,
            from: message.sender,
            body: message.contents
          )

        response_code == ResponseCodes::SUCCESS
      end
    end
  end
end
