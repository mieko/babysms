require 'rainbow/refinement'
require 'twilio-ruby'
require_relative 'base_adapter'

using Rainbow

module BabySMS
  module Adapters
    class TwilioAdapter < BaseAdapter

      attr_accessor :verbose
      attr_accessor :outbox
      attr_accessor :account_sid
      attr_accessor :auth_token

      def initialize(verbose: false)
        self.verbose = verbose
        @client      = Twilio::REST::Client.new(account_sid, auth_token)
      end

      # validate do
      #   errors.add(:client, "There was a problem with the client: #{@client.errors}") if @client.errors.present?
      # end

      def deliver_now(message)
        # Validations


        validates_presence_of :auth_token
        validates_presence_of :account_sid
        raise_validation_error unless valid?

        @client.api.account.messages.create(
          from: '+14159341234',
          to:   '+16105557069',
          body: 'Hey there!'
        )

        # set up a client to talk to the Twilio REST API
        client.

          end

        $stdout.puts "#{"SMS:".bright.yellow} -> #{message.recipient.bright.yellow}: \n" \
                     ">> #{message.contents.white}"
      end

      private

      def client

      end
    end
  end
end
