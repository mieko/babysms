require 'active_support/concern'
require 'babysms/concerns/process_messages_concern'
require 'twilio-ruby'

module BabySMS
  module Services
    module Twilio
      class ProcessMessages
        using Concerns::ServiceObject

        def initialize(**args)
          super

          @messages = args[:messages]
        end

        def call
          @messages.each do |m|
            BabySMS::DeliverMessage.call(
              to:   m.recipient,
              from: m.sender,
              body: m.contents
            )
          end
        end

      end
