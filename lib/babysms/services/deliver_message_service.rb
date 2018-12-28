require 'active_support/concern'
require 'twilio-ruby'

module BabySMS::Services
  using BaseService
  module DeliverMessage

    def call
      @client ||= Twilio::REST::Client.new(@account_sid, @auth_token)
    end
  end
end
