require "active_model"
require "phony_rails"

module BabySMS
  class Message
    include ActiveModel::Model
    include ActiveModel::Validations::Callbacks

    attr_accessor :recipient, :recipient_as_normalized
    phony_normalize :recipient, default_country_code: 'US'
    validates :recipient, presence: true,
                          phony_plausible: true

    attr_accessor :contents
    validates :contents, presence: true,
                         length: { maximum: 160 }

    def deliver_now
      raise_validation_error unless valid?

      BabySMS.adapter.deliver_now(self)
    end

  end
end
