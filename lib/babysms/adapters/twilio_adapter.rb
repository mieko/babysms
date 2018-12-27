require 'rainbow/refinement'
require 'twilio-ruby'

require_relative 'base_adapter'

module BabySMS
  module Adapters
    class TwilioAdapter < BaseAdapter

      include ActiveModel
      include ActiveModel::Validations

      attr_accessor :verbose
      attr_accessor :outbox
      attr_accessor :account_sid
      attr_accessor :auth_token

      def initialize(verbose: false)
        self.verbose = verbose
        @client      = Twilio::REST::Client.new(account_sid, auth_token)
      end

      validates :account_sid, presence: true
      validates :auth_token, presence: true

      def deliver_now(message)

        raise_validation_error unless valid?
        @client.api.account.messages.create(
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
