require 'babysms/concerns/service_object'

module BabySMS
  module Services
    class ProcessMessages
      using ActiveModel
      using ActiveSupport::Concern
      using ServiceObject

      private

      attr_accessor :messages

      public

      def call!
        return false unless @messages.all?(&:valid?)

        @messages.each do |m|
          BabySMS.send_message(
            to:   m.recipient,
            from: m.sender,
            body: m.contents
          )
        end
        true
      end
    end
  end
end
