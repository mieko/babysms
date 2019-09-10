require 'rainbow/refinement'
using Rainbow

module BabySMS
  module Adapters
    class TestAdapter < BabySMS::Adapter
      attr_accessor :verbose
      attr_accessor :fails
      attr_accessor :outbox

      def initialize(verbose: false, fails: false, from: '+15558675309')
        super(from: from)
        self.verbose = verbose
        self.fails = fails
        self.outbox = []
      end

      def deliver(message)
        if fails
          raise BabySMS::FailedDelivery.new('intentional failure', adapter: self)
        end

        outbox.push(message)
        if verbose
          display_message = <<~"MSG"
            #{"SMS:".bright.yellow} -> #{message.recipient.bright.yellow}:
              >> #{message.contents.white}
          MSG

          $stderr.puts display_message
        end
      end
    end
  end
end
