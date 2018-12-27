require 'active_model'
require 'active_model/validations'

module BabySMS
  module Adapters
    class BaseAdapter
      include ActiveModel
      include ActiveModel::Validations

      attr_accessor :verbose
      attr_accessor :outbox

      def initialize(**args)
        self.verbose = args[:verbose]
      end

      def deliver_now(message)
        raise_validation_error unless valid?
      end
    end
  end
end
