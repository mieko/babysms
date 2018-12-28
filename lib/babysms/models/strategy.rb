require 'active_support/callbacks'
require 'rainbow/refinement'

module BabySMS
  module Strategy

    include ActiveModel::Model
    include ActiveSupport::Concern

    delegate :send_message, to: :strategy, allow_nil: false

    validates :strategy, presence: true

    protected

    attr_accessor :strategy
    attr_accessor :verbose

    public

    def initialize(verbose: true, strategy:,)
      @verbose  = verbose
      @strategy = strategy
    end

  end
end
