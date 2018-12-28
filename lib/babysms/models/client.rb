require 'active_support/callbacks'
require 'rainbow/refinement'

=begin

client = BabySMS::Client.new
client.strategies << BabySMS::Strategies::Twilio.call(account_sid, auth_token)
client.messages << Message.new(...)
client.messages << Message.new(...)

if BabySMS.send_messages!
  puts "It worked!"
else
  puts "FAILURE!"
end

=end

###########################################################################
module BabySMS

  ###########################################################################
  class Client
    include ActiveModel::Model
    include ActiveSupport::Concern

    ###########################################################################

    protected

    attr_accessor :verbose
    attr_accessor :strategies
    attr_accessor :messages

    delegate :send_messages!, to: :strategy, allow_nil: false

    public

    ###########################################################################
    validates :strategy, presence: true

    ###########################################################################
    def initialize(verbose: true, strategies: [], messages: [])
      @verbose    = verbose
      @strategies = @strategies.to_a
      @messages   = messages.to_a
    end

    private

    # Select the first strategy that responds to #ready?
    def strategy
      @strategies.detect(&:ready?)
    end

  end
end
