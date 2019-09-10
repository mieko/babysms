require 'rainbow/refinement'
using Rainbow

module BabySMS
  module Adapters
    class TestAdapter
      attr_accessor :verbose
      attr_accessor :fails
      attr_accessor :outbox

      def initialize(verbose: false, fails: false)
        self.verbose = verbose
        self.fails = fails
        self.outbox = []
      end

      def deliver_now(message)
        if fails
          fail BabySMS::Message::FailedDelivery, "intentional failure"
        end

        outbox.push(message)
        if verbose
          $stdout.puts "#{"SMS:".bright.yellow} -> #{message.recipient.bright.yellow}: \n" \
                       ">> #{message.contents.white}"
        end
      end
    end
  end
end
