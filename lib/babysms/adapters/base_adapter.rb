module BabySMS
  module Adapters

    # TODO: What is the INTERFACE of an "Adapter"?

    class BaseAdapter
      def initialize(**args)
        @verbose = args[:verbose] || false
        @outbox  = args[:outbox] || []
        @purge   = args[:purge] || true
      end

    end

  end
end
