require 'active_model'
require 'active_support/concern'

module BabySMS
  module Concerns
    module ServiceObject

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
