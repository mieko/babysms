module BabySMS
  class InvalidMessage < BabySMS::Error
  end

  class Message
    attr_accessor :recipient
    attr_accessor :contents

    def initialize(recipient:, contents:)
      @recipient = Phony.normalize(recipient)
      @contents = contents
    end

    def deliver(adapters: BabySMS.adapters, strategy: BabySMS.strategy)
      validate!
      BabySMS::MailMan.new(adapters: adapters, strategy: strategy).deliver(self)
    end

    private

    MAX_CONTENTS_LENGTH = 1600

    def validate!
      validate_recipient!
      validate_contents!
    end

    def validate_recipient!
      if recipient.blank?
        fail BabySMS::InvalidMessage, 'no recipient'
      end

      unless Phony.plausible?(recipient)
        fail BabySMS::InvalidMessage, "implausible recipient: #{recipient}"
      end
    end

    def validate_contents!
      if contents.blank?
        fail BabySMS::InvalidMessage, 'no contents'
      end

      if contents.size > MAX_CONTENTS_LENGTH
        msg = "contents too long (#{contents.size} vs max of #{MAX_CONTENTS_LENGTH}); " \
              "contents: `#{contents}`"
        fail BabySMS::InvalidMessage, msg
      end
    end
  end
end
