require 'active_model'
require 'active_model/validations'
require 'rainbow/refinement'

using Rainbow
module BabySMS
  module Adapters
    class BaseAdapter
      include ActiveModel
      include ActiveModel::Validations

      attr_accessor :verbose
      attr_accessor :outbox

      def initialize(**args)
        self.verbose = args[:verbose] || false
        self.outbox  = []
      end

      def deliver_now(message)
        raise_validation_error unless valid?

        return if verbose.blank?

        $stdout.puts "#{"SMS:".bright.yellow} -> #{message.recipient.bright.yellow}: \n" \
                     ">> #{message.contents.white}"
      end
    end
  end
end
