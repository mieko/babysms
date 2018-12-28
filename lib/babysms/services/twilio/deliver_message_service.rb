require 'babysms/models/concerns/services_concern'
require 'babysms/models/concerns/deliver_message_concern'
require 'twilio-ruby'

module BabySMS
  module Strategies
    class DeliverMessage

    end


    def initialize(**args)
      super

      @account_sid = args[:account_sid]
      @auth_token  = args[:auth_token]
    end

    def call
      @client ||= Twilio::REST::Client.new(@account_sid, @auth_token)
    end

  end
