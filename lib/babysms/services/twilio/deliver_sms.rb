require 'twilio-ruby'
require_relative '../base_adapter'

module BabySMS
  module Services
    module Twilio
      class DeliverSms < BaseService

        def initialize(**args)
          super

          @account_sid = args[:account_sid]
          @auth_token  = args[:auth_token]
        end

        def call
          @client ||= Twilio::REST::Client.new(@account_sid, @auth_token)
        end

      end
    end
  end
end
