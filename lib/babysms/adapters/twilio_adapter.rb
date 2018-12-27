require 'rainbow/refinement'
require 'twilio-ruby'

require_relative 'base_adapter'

module BabySMS
  module Adapters
    class TwilioAdapter < BaseAdapter
      attr_accessor :account_sid
      attr_accessor :auth_token
      attr_accessor :client

      validates :account_sid, presence: true
      validates :auth_token, presence: true

      def initialize(account_sid:, auth_token:, verbose: false)
        super

        self.account_sid = account_sid
        self.auth_token  = auth_token
        self.client      = Twilio::REST::Client.new(account_sid, auth_token)
      end

      def deliver_now(message)
        super

        client.api.account.messages.create(
          from: '+14159341234',
          to:   '+16105557069',
          body: 'Hey there!'
        )
        $stdout.puts "#{"SMS:".bright.yellow} -> #{message.recipient.bright.yellow}: \n" \
                     ">> #{message.contents.white}"
      end

      private

      def client

      end
    end
  end
end
