require 'twilio-ruby'

module BabySMS
  module Services
    class BaseService

      def initialize(verbose: true)
        @verbose = verbose
      end

      def self.call(**args)
        new(**args).call
      end

      def call
        fail 'Missing implementation'
      end

    end
  end
end
