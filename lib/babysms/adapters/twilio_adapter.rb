require 'rainbow/refinement'
require 'twilio-ruby'

require_relative 'base_adapter'

require 'rainbow/refinement'

using Rainbow
module BabySMS
  module Adapters
    class TwilioAdapter < BaseAdapter
      attr_accessor :account_sid
      attr_accessor :auth_token

      validates :account_sid, presence: true
      validates :auth_token, presence: true

      def initialize(**args)
        super

        @account_sid = args[:account_sid]
        @auth_token  = args[:auth_token]
      end

      def deliver_now(message)
        outbox << message

        super

        outbox.each do |m|
          client.api.account.messages.create(to: m.recipient, body: m.contents)
        end

        true
      end

      private

      def client
        @client ||= Twilio::REST::Client.new(@account_sid, @auth_token)
      end
    end
  end
end
