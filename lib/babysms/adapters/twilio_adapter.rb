require 'twilio-ruby'
require_relative 'base_adapter'

module BabySMS
  module Adapters

    class TwilioAdapter < BaseAdapter

      RESPONSE_CODES = [
        success:       '',
        invalid:       21212,
        non_mobile:    21606,
        messages_full: 21611
      ].freeze

      MESSAGES = {
        '21212': "This phone number is invalid.",
        '21606': "This phone number is not owned by your account or is not SMS-capable.",
        '21611': "This number has an SMS message queue that is full."
      }.freeze

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

        response_code == RESPONSE_CODES[:success]
      end
    end
  end
end
