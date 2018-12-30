require "active_model"
require "phony_rails"

module BabySMS
  class Message
    class FailedDelivery < StandardError
    end

    include ActiveModel::Model
    include ActiveModel::Validations::Callbacks

    attr_accessor :recipient, :recipient_as_normalized
    phony_normalize :recipient, default_country_code: 'US'
    validates :recipient, presence: true,
                          phony_plausible: true

    attr_accessor :contents

    # 1600 is the safe limit for most handsets to stitch together messages.
    validates :contents, presence: true,
                         length: { maximum: 1600 }

    def deliver_now
      raise_validation_error unless valid?

      BabySMS.adapters.each do |adapter|
        adapter.deliver_now(self)
        break
      rescue FailedDelivery => e
        warn "Failed SMS delivery: #{e}"
        next
      end
    end
  end
end
