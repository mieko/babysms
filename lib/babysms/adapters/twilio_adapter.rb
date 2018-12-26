require 'rainbow/refinement'
using Rainbow

module BabySMS
  module Adapters
    class TwilioAdapter
      attr_accessor :verbose
      attr_accessor :outbox

      def initialize(verbose: false)
        self.verbose = verbose
        self.outbox  = []
      end

      def deliver_now(message)
        outbox.push(message)
        if verbose
          $stdout.puts "#{"SMS:".bright.yellow} -> #{message.recipient.bright.yellow}: \n" \
                       ">> #{message.contents.white}"
        end
      end
    end
  end
end
