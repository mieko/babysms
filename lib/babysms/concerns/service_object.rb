require 'active_model'
require 'active_support/concern'

module BabySMS
  module Concerns
    class ServiceObject

      using ActiveModel::Model
      using ActiveSupport::Concern

      class << self
        def call(**args)
          new(**args).call
        end
      end

      def call
        fail 'Missing implementation'
      end

    end
  end
end
