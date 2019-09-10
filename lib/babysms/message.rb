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

    # adapter can be set to an Adapter or an array of Adapters.
    # omitting it uses the default-configured BabySMS.adapters
    def deliver_now(adapters: BabySMS.adapters)
      raise_validation_error unless valid?

      raise FailedDelivery, "No adapter configured" if adapters.empty?

      # try all adapters in order, returning when one succeeds.  Collect
      # errors until then.
      errors = []

      adapters.each do |adapter|
        adapter.deliver_now(self)
        break
      rescue FailedDelivery => e
        errors.push(e)
      end

      # never got delivered: error
      if errors.size == adapters.size
        raise FailedDelivery.new(errors)
      end

      # got delivered, report any errors
      return errors
    end
  end
end
