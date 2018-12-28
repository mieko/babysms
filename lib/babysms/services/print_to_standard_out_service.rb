require 'rainbow/refinement'
require 'babysms/concerns/service_object'

module BabySMS
  module Service
    module PrintToStandardOut
      using Rainbow
      using ServiceObject

      private

      attr_accessor :message

      public

      def initialize(message:)
        @message = message
      end

      def call
        print_message @message
      end

      private

      def print_message(_message)
        $stdout.puts "#{"SMS:".bright.yellow} -> #{_message.recipient.bright.yellow}: \n" \
                   ">> #{_message.contents.white}"
      end

    end
  end
end
