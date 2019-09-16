require 'rainbow/refinement'
using Rainbow

module BabySMS
  module Adapters
    class TestAdapter < BabySMS::Adapter
      attr_accessor :verbose
      attr_accessor :fails
      attr_accessor :outbox

      def initialize(verbose: false, fails: false, from: '+1555-555-5555')
        super(from: from)

        self.verbose = verbose
        self.fails = fails
        self.outbox = []

        reset_message_uuid
      end

      def deliver(message)
        if fails
          raise BabySMS::FailedDelivery.new('intentional failure', adapter: self)
        end

        outbox.push(message)
        if verbose
          terminal_output = <<~"MSG"
            #{"SMS:".bright.yellow} -> #{message.recipient.bright.yellow}:
              >> #{message.contents.white}
          MSG
          $stderr.puts terminal_output
        end

        next_message_uuid
      end

      def reset_message_uuid
        @message_uuid = 0
      end

      private

      def next_message_uuid
        @message_uuid += 1
        @message_uuid.to_s
      end
    end
  end
end
