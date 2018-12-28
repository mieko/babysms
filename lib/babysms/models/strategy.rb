require 'active_support/callbacks'
require 'rainbow/refinement'

module BabySMS
  class Strategy

    include ActiveModel::Model
    include ActiveSupport::Concern
    include ActiveSupport::Callbacks

    set_callbacks

    protected

    attr_accessor :messages
    attr_accessor :strategy
    attr_accessor :verbose

    delegate :call, to: :strategy, allow_nil: false

    public

    validates :messages, presence: true
    validates :strategy, presence: true

    def initialize(messages:, verbose: true, strategy:,)
      @messages = messages || []
      @verbose  = verbose
      @strategy = strategy
    end

    def call
      fail 'Missing implementation'
    end

    def strategy=(strategy)
      super

      set_callback :send_message, :after do |object|
        # Some shit
      end
    end

  end
end
